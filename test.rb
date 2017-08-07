#!/usr/bin/ruby

# Script to print repos not updated since given time
# Added by: Harpal Dhillon
# Date: 2017-02-09

# Include gems
require 'rubygems'
require 'nokogiri'

# Set this value in minutes as per requirement
# Here set to 30 days (60*24*30)
TIME_PERIOD = 43200

# Open html file here
doc = Nokogiri::HTML(open("git.html"))   

# Add only table available
table = doc.at('table')

# Look for rows
table.search('tr').each do |tr|
  cells = tr.search('th, td')

  col1 = cells[0].text.gsub(/\s+/, " ").strip
  col4 = cells[4].text.strip

  slot = col4.gsub(/[^\d]/, '').to_i

  if col4.include? 'mins'
     duration = slot

    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end

  if col4.include? 'hours'
     duration = slot*60   #Convert to minutes

    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end 

  if col4.include? 'days'
     duration = slot*60*24  #Convert to minutes

    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end

  if col4.include? 'weeks'
     duration = slot*60*24*7   #Convert to minutes
     
    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end

  if col4.include? 'months'
     duration = slot*60*24*30   #Convert to minutes

    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end

  if col4.include? 'years'
     duration = slot*60*24*30*12   #Convert to minutes

    if duration >= TIME_PERIOD
       puts "#{col1}:#{col4}"
    end
  end

end
