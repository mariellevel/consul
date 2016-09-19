class CensusApi::Request
  attr_accessor :document_type, :document_number

  def initialize(document_type, document_number)
    @document_type   = document_type
    @document_number = document_number
  end

  def call
    if end_point_available?
      document_variants.each do |variant|
        response = CensusApi::Response.new(client_call(variant))
        return response if response.valid?
      end
      return nil
    else
      stubbed_response_body
    end
  end

  private

    def client
      @client = Savon.client(wsdl: Rails.application.secrets.census_api_end_point)
    end

    def client_call(document_number_variant)
      client.call(:get_habita_datos, message: request(document_number_variant)).body
    end

    def request(document_number_variant)
      { request:
        { codigo_institucion: Rails.application.secrets.census_api_institution_code,
          codigo_portal:      Rails.application.secrets.census_api_portal_name,
          codigo_usuario:     Rails.application.secrets.census_api_user_code,
          documento:          document_number_variant,
          tipo_documento:     document_type,
          codigo_idioma:      102,
          nivel: 3 }}
    end

    def end_point_available?
      Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?
    end

    def stubbed_response_body
      {get_habita_datos_response: {get_habita_datos_return: {hay_errores: false, datos_habitante: { item: {fecha_nacimiento_string: "31-12-1980", identificador_documento: "12345678Z", descripcion_sexo: "Varón" }}, datos_vivienda: {item: {codigo_postal: "28013", codigo_distrito: "01"}}}}}
    end

    def document_variants
      CensusApi::DocumentVariants(document_type, document_number).all
    end

end