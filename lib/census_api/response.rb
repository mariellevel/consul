class CensusApi::Response
  attr_accessor :body

  def initialize(body)
    @body = body
  end

  def valid?
    data[:datos_habitante][:item].present?
  end

  def date_of_birth
    str = data[:datos_habitante][:item][:fecha_nacimiento_string]
    day, month, year = str.match(/(\d\d?)\D(\d\d?)\D(\d\d\d?\d?)/)[1..3]
    return nil unless day.present? && month.present? && year.present?
    Date.new(year.to_i, month.to_i, day.to_i)
  end

  def postal_code
    data[:datos_vivienda][:item][:codigo_postal]
  end

  def district_code
    data[:datos_vivienda][:item][:codigo_distrito]
  end

  def gender
    case data[:datos_habitante][:item][:descripcion_sexo]
    when "Varón"
      "male"
    when "Mujer"
      "female"
    end
  end

  private

    def data
      body[:get_habita_datos_response][:get_habita_datos_return]
    end
end