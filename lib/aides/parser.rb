require 'rubygems'
require 'nokogiri'
require 'ostruct'

module Aides
  module Parser

    class StopSummary
      ROOT = "RoutesForStopData"
      def parse(stop_data)
        doc = Nokogiri::XML(stop_data).css(ROOT)
        summary = {}
        summary[:number] = doc.css("StopNo").first.content.to_i
        summary[:description] = doc.css("StopDescription").first.content
        summary[:error] = doc.css("Error").reduce(""){|r,n| "#{r}#{n.content}"}
        summary[:routes] = doc.css("Routes Route").map{|node| route(node)}

        summary
      end

      def route(node)
        route = {}
        route[:number] = node.css('RouteNo').first.content.to_i
        route[:direction_id] = node.css('DirectionID').first.content.to_i
        route[:direction] = node.css('Direction').first.content
        route[:heading] = node.css('RouteHeading').first.content
        route
      end

      def to_json
        @contents.to_json
      end
    end

    class StopInfoData
      ROOT = "StopInfoData"
      
      def parse(stop_data)
        doc = Nokogiri::XML(stop_data).css(ROOT)
        info = {}
        info[:number] = doc.css("StopNo").first.content.to_i
        info[:label]  = doc.css("StopLabel").first.content
        info[:error]  = doc.css("Error").first.content
        info[:routes] = doc.css("Route RouteDirection").map{|node| direction(node)}
        info
      end

      def direction(node)
        direction = {}
        direction[:number]          = node.css("RouteNo").first.content.to_i
        direction[:label]           = node.css("RouteLabel").first.content
        direction[:direction]       = node.css("Direction").first.content
        direction[:error]           = node.css("Error").first.content
        direction[:processing_time] = node.css("RequestProcessingTime").first.content
        direction[:trips]           = node.css("Trips Trip").map{|node| trip(node)}
        direction
      end

      def trip(node)
        trip = {}
        trip[:destination] = node.css("TripDestination").first.content
        trip[:start_time]  = node.css("TripStartTime").first.content
        trip[:adjusted_schedule_time] = node.css("AdjustedScheduleTime").first.content
        trip[:adjustment_age] = node.css("AdjustmentAge").first.content
        trip[:is_last_trip] = node.css("LastTripOfSchedule").first.content == "true"
        trip[:bus_type] = node.css("BusType").first.content

        gps_speed = node.css("GPSSpeed").first
        trip[:gps_speed] = gps_speed.nil? ? nil : gps_speed.content

        speed = node.css("Speed").first
        trip[:speed] = speed.nil? ? nil : speed.content
        
        trip[:lat] = node.css("Latitude").first.content
        trip[:lng] = node.css("Longitude").first.content
        trip
      end

    end
  end
end
