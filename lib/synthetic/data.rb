require 'faker'
require 'json'
require 'csv'
require 'yaml'
require 'date'
require "synthetic/data/version"

module Synthetic
  module Data
    class Error < StandardError; end

    # Faker::Config.locale = 'en-CA'

    # definition = YAML.load_file(ARGV[0])
    
    # headers = []
    # for field in definition['fields'].keys do
    #     headers.push(field)
    # end
    
    # options = {
    #     :write_headers => true,
    #     :headers => headers.join(',')
    # }
    
    # start = Time.now.to_i
    
    # CSV.open(definition['output'], "wb", options) do |csv|
    
    #     for i in 1..definition['records'] do
    
    #         row = []
    #         for f in definition['fields'].keys do
    #             field = definition['fields'][f]
    
    #             type = field['type'].split '.'
    
    #             args = {}
    #             for key in field.keys do
    #                 if not ['type','unique'].include? key then
    
    #                     if field[key].is_a? String and field[key].start_with? '@' then
    #                         args[:"#{key}"] = row[headers.index(field[key][1..-1])]
    #                     else
    #                         args[:"#{key}"] = field[key]
    #                     end
    #                 end
    #             end
    
    #             obj = Faker.const_get(type[0])
    #             if field['unique'] then
    #                 obj = obj.public_send('unique')
    #             end
    
    #             if field.keys.length == 1 then
    #                 row.push(obj.public_send(type[1]))
    #             else
    #                 row.push(obj.public_send(type[1], args))
    #             end
    #         end
    #         csv.puts(row)
    
    #         if i % 1000 == 0 then
    #             elapsed = Time.now.to_i - start
    #             puts("Completed #{i} records.  Total elapsed #{elapsed} seconds.")
    #         end
    #     end
    # end
    
    # print "CSV file written (#{definition['output']})"

  end
end