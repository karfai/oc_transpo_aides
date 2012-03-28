require 'test_helper'
require 'aides/parser'
require 'nokogiri'
require 'test/unit'

class ParserTest < Test::Unit::TestCase
  def setup
    @stop_parser = Aides::Parser::StopSummary.new
    @info_parser = Aides::Parser::StopInfoData.new
    @bus_stop_xml = Aides::Helpers.load_fixture('data_stop_3017.xml')
    @stop_info_xml = Aides::Helpers.load_fixture('stop_info_data_3017.xml')
  end

  def test_parser_extracts_stop_information
    stop = @stop_parser.parse(@bus_stop_xml)
    assert_equal 3017, stop[:number]
    assert_equal "NAVAHO / BASELINE STATION", stop[:description]
    assert_equal "", stop[:error]
    assert stop[:routes]
  end

  def test_parser_extracts_stop_route_info
    routes = @stop_parser.parse(@bus_stop_xml)[:routes]
    assert_equal 11, routes.length
    expected_keys = [:number, :direction_id, :direction, :heading].sort
    assert_equal expected_keys, routes.first.keys.sort
  end

  def test_parser_extracts_stop_info
    info = @info_parser.parse(@stop_info_xml)
    assert_equal 3017, info[:number]
    assert_equal "NAVAHO 	BASELINE STATION", info[:label]
    assert_equal "", info[:error]
    assert info[:routes]
  end

  def test_parser_extracts_route_details
    routes = @info_parser.parse(@stop_info_xml)[:routes]
    assert_equal 2, routes.length
    expected_direction_keys = [:number, :label, :direction, :error, :processing_time, :trips]
    assert_equal expected_direction_keys.sort, routes.first.keys.sort
  end

  def test_parser_extracts_trip_details
    doc = Nokogiri::XML(@stop_info_xml).css("Trips Trip")
    trip = @info_parser.trip(doc.first)
    expected_keys = [
                     :destination,
                     :start_time,
                     :adjusted_schedule_time,
                     :adjustment_age,
                     :is_last_trip,
                     :bus_type,
                     :gps_speed,
                     :speed,
                     :lat,
                     :lng
                    ]
    assert_equal expected_keys.sort, trip.keys.sort
  end
end
