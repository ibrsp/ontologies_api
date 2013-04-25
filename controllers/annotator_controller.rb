class AnnotatorController < ApplicationController
  namespace "/annotator" do

    # execute an annotator query
    get do
      text = params["text"]
      raise error 400, "A text to be annotated must be supplied using the argument text=<text to be annotated>" if text.nil? || text.strip.empty?
      ontologiesStr = params["ontologies"] || ""
      max_level = params["max_level"].to_i || 0
      ontologies = ontologiesStr.split(",").map {|e| e.strip}
      annotator = Annotator::Models::NcboAnnotator.new
      annotations = annotator.annotate(text, ontologies, max_level)
      reply 200, annotations
    end

    post '/dictionary' do
      annotator = Annotator::Models::NcboAnnotator.new
      annotator.generate_dictionary_file
    end

    post '/cache' do
      annotator = Annotator::Models::NcboAnnotator.new
      annotator.create_term_cache
    end

    private

    def get_page_params(text, args={})
      return args
    end
  end
end
