require 'ocr_space/file_post'
module OcrSpace
  module Convert
    def convert(apikey: @api_key, language: 'eng', filetype: nil, isOverlayRequired: false,
      file: nil, url: nil, scale: true, isTable: true)

      unless file || url
        @errors << "You need to Pass either file or url."
        return nil
      end

      body = { apikey: apikey,
        language: language,
        filetype: filetype,
        isOverlayRequired: isOverlayRequired,
        scale: scale,
        isTable: isTable}

        begin
          if file
            body[:file] = File.new(file)
            @data = OcrSpace::FilePost.post('/parse/image', body: body)
          elsif url
            body[:url] = url
            @data = HTTParty.post('https://api.ocr.space/parse/image', body: body)
          end
        rescue Exception => e
          @errors << e
          return
        end
        
        if not @data
          @errors << "No response received."
          nil
        elsif not @data.parsed_response['ParsedResults']
          @errors += @data.parsed_response['ErrorMessage']
          nil
        else
          @data = @data.parsed_response['ParsedResults']
        end
      end

      def clean_convert(apikey: @api_key, language: 'eng', filetype: nil, isOverlayRequired: false,
        file: nil, url: nil, scale: true, isTable: true, remove: /\r|\n/)
        @data = convert(apikey: apikey, language: language, filetype: filetype, isOverlayRequired: isOverlayRequired, file: file, url: url)

        # Read text per page and join pages
        @data = @data && @data.map{|data|data["ParsedText"]}.join("\r\n").gsub(remove, "")
      end
    end
  end
