# coding: utf-8

class HolidaysController < ApplicationController

  respond_to :html, :json

  before_filter :set_json_path

  def index
    @holidays = Holidays.on(Date.today, :de_)

    @requested_date = Date.today

    respond_with @holidays do |format|
      format.html { render 'index' }
    end
  end

  def show
    begin
      if params[:second]
        date = Date.parse params[:second]
        region = parse_region params[:first]
      else
        if params[:first]
          date = Date.parse params[:first] rescue nil
          region = parse_region params[:first] rescue nil

          if region.nil? && date.nil?
            raise ArgumentError
          end
        end

        date = Date.today if date.nil?
      end
    rescue
      render text: 'Bad request', status: :bad_request
      return
    end

    logger.debug({date: date, region: region}.to_s)

    lookup_region = region ? "de_#{region}".to_sym : :de_

    if Holidays::DE.defined_regions.include? lookup_region
      @holidays = Holidays.on(date, lookup_region)
    else
      @holidays = Holidays.on(date, :de_)

      unless lookup_region == :de_ || @holidays.any?{|h| h[:regions].include? :de}
        @holidays = []
      end
    end

    @requested_date = date
    @requested_region = region

    respond_with @holidays do |format|
      format.html { render 'index' }
    end
  end

  def imprint
  end

  private

  MAPPING = {
    'bw' => 'Baden-Württemberg',
    'by' => 'Bayern',
    'be' => 'Berlin',
    'bb' => 'Brandenburg',
    'hb' => 'Bremen',
    'hh' => 'Hamburg',
    'he' => 'Hessen',
    'mv' => 'Mecklenburg-Vorpommern',
    'ni' => 'Niedersachsen',
    'nw' => 'Nordrhein-Westfalen',
    'rp' => 'Rheinland-Pfalz',
    'sl' => 'Saarland',
    'sn' => 'Sachsen',
    'st' => 'Sachsen-Anhalt',
    'sh' => 'Schleswig-Holstein',
    'th' => 'Thüringen'
  }

  REVERSE = Hash[MAPPING.to_a.map{|m| [m[1].downcase, m[0]]}]

  def parse_region value
    sanitized = value.downcase

    region = sanitized if MAPPING.keys.include?(sanitized)

    region ||= REVERSE[sanitized]

    raise ArgumentError if region.nil?

    return region
  end

  def set_json_path
    if request.fullpath == '/'
      @json_path = today_path + '.json'
    else
      @json_path = request.fullpath + '.json'
    end
  end
end

