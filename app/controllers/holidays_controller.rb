# coding: utf-8

class HolidaysController < ApplicationController

  respond_to :html, :json

  def index
    @holidays = Holidays.on(Date.today, :de_)

    respond_with(@holidays)
  end

  def show
    begin
      if params[:second]
        date = Date.parse params[:second]
        region = parse_region params[:first]
      else
        date = Date.parse params[:first] rescue nil
        region = parse_region params[:first] rescue nil

        if region.nil? && date.nil?
          raise ArgumentError
        end

        region = :de_ if region.nil?
        date = Date.today if date.nil?
      end

      logger.debug({date: date, region: region}.to_s)

      @holidays = Holidays.on(date, region)

      respond_with @holidays do |format|
        format.html { render 'index' }
      end
    rescue
      respond_with status: :bad_request
    end
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

    result = "de_#{region}".to_sym

    return result if Holidays::DE.defined_regions.include? result

    return :de_
  end
end

