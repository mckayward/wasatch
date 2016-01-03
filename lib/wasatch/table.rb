require_relative "station"
require "nokogiri"
require "open-uri"
require "nexmo"

class Table

  attr_reader :table, :message
  attr_accessor :stations, :numbers

  def initialize(runner)
    @runner   = runner
    @site_url = "http://results.wasatch100.com/Runner/Details/#{@runner_number}"
    @page     = Nokogiri::HTML(open(@site_url))
    @table    = @page.css('table.runnerprogress > tbody > tr')
    @stations = new_stations
  end

  def new_stations
    stations = []
    @table.each do |row|
      stations << Station.new(row.css('td.display-field'))
    end
    return stations
  end

  def message(station)
    "RACE UPDATE:\n"\
    "#{@runner.name} arrived at #{station.name} "\
    "(mile #{station.mile.to_f}) at #{station.in} "\
    "#{"and left at #{station.out}." if station.out != ''}"\
    "\nRoughly #{100 - station.mile.to_i} miles to go."
  end

  def ==(othertable)
    @stations == othertable.stations
  end

  def difference(othertable)
    diffs = []
    othertable.stations.each_with_index do |station, index|
      diffs << station if station != @stations[index]
    end

    send_texts(diffs[-1]) unless diffs.empty?
    print '.' if  diffs.empty?
  end

  def send_texts(station)
    @runner.numbers.each do |number|
      nexmo = Nexmo::Client.new(key: ENV['NEXMO_API_KEY'], secret: ENV['NEXMO_API_SECRET'])
      nexmo.send_message(from: ENV['NEXMO_NUMBER'], to: number, text: message(station))
      sleep(1)
    end
  end
end
