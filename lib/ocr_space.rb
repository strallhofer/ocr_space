require 'ocr_space/version'
require 'ocr_space/convert'
require 'ocr_space/banner'

module OcrSpace
  class Resource
    attr_reader :data, :errors

    include OcrSpace::Convert

    def initialize(apikey: ENV['ocr_api_key'])
      @api_key = apikey
      @data = nil
      @errors = []
    end
  end
end
