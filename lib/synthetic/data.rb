require 'faker'
require 'json'
require 'csv'
require 'yaml'
require 'date'
require "synthetic/data/version"
require 'digest'

module Synthetic
    class Error < StandardError; end

    def self.bulk(folder)
        Dir.entries(folder).select {|f| 
            if not File.directory? "#{folder}/#{f}" and not [".",".."].include? f then
                puts "Process #{f}"
                self.generate("#{folder}/#{f}")
            end
        }
    end

    def self.generate(rules_file)

        Faker::Config.locale = 'en-CA'

        definition = YAML.load_file(rules_file)
        
        if self.check(rules_file, definition) == false
            return
        end

        headers = []
        for field in definition['fields'].keys do
            headers.push(field)
        end
        
        options = {
            :write_headers => true,
            :headers => headers.join(',')
        }
        
        start = Time.now.to_i
        
        output = "outputs/" + definition['output']
        CSV.open(output, "wb", options) do |csv|
        
            for i in 1..definition['records'] do
        
                row = []
                for f in definition['fields'].keys do
                    field = definition['fields'][f]
        
                    type = field['type'].split '.'
        
                    args = {}
                    for key in field.keys do
                        if not ['type','unique'].include? key then
        
                            if field[key].is_a? String and field[key].start_with? '@' then
                                args[:"#{key}"] = row[headers.index(field[key][1..-1])]
                            else
                                args[:"#{key}"] = field[key]
                            end
                        end
                    end
        
                    obj = Faker.const_get(type[0])
                    if field['unique'] then
                        obj = obj.public_send('unique')
                    end
        
                    if field.keys.length == 1 then
                        row.push(obj.public_send(type[1]))
                    else
                        row.push(obj.public_send(type[1], args))
                    end
                end
                csv.puts(row)
        
                if i % 1000 == 0 then
                    elapsed = Time.now.to_i - start
                    puts("Completed #{i} records.  Total elapsed #{elapsed} seconds.")
                end
            end
        end
        
        puts "CSV file written (#{output})"

        self.register(rules_file, definition)
    end

    def self.register(filename, obj)
        hash = Digest::SHA256.hexdigest obj.to_yaml
        if File.exists? 'outputs/data-version.txt'
            data_hash = JSON.parse(File.read('outputs/data-version.txt'))
        else
            data_hash = {}
        end
        data_hash[filename] = hash
        File.open('outputs/data-version.txt',"w") do |f|
            f.write(JSON.pretty_generate(data_hash))
        end
    end

    def self.check(filename, obj)
        hash = Digest::SHA256.hexdigest obj.to_yaml
        if File.exists? 'outputs/data-version.txt'
            data_hash = JSON.parse(File.read('outputs/data-version.txt'))
            if data_hash.key? filename and hash == data_hash[filename]
                puts("#{filename} - Already generated")
                return false
            end
        end
        return true
    end
end
