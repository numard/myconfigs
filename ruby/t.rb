#!/usr/bin/env ruby

require 'yaml'
file_name = "./puppet/hiera/au/hostclass/prometheus.yaml"

loaded_yaml = YAML.load_file(file_name)
# @source_and_target_cols_map = config_options['source_and_target_cols_map']
puts loaded_yaml
puts "======="

loaded_yaml.each do |k,v| 
    puts "Key: ", k
    puts "Value: " , v
    puts 
end
