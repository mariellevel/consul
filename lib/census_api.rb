class CensusApi

  def call(document_type, document_number)
    request = CensusApi::Request.new(document_type, document_number).call
    CensusApi::Response.new(request)
  end

end
