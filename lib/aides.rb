require 'rubygems'
require 'sinatra'
require 'json'
#require 'aides/oct_client'
require './aides/parser'
require '../test/test_helper'

get '/stop_summary' do
  content_type :json
  parser = Aides::Parser::StopSummary.new
  doc_str = Aides::Helpers.load_fixture('data_stop_3017.xml')
  parser.parse(doc_str).to_json
end

get '/stop_info' do
  content_type :json
  parser = Aides::Parser::StopInfoData.new
  doc_str = Aides::Helpers.load_fixture('stop_info_data_3017.xml')
  parser.parse(doc_str).to_json
end

