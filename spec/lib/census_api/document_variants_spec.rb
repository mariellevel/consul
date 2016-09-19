require 'rails_helper'

describe CensusApi::DocumentVariant do

  describe '#document_variants' do

    it "trims and cleans up entry" do
      document_variants = CensusApi::DocumentVariant.new(2, '  1 2@ 34')
      expect(document_variants.all).to eq(['1234'])
    end

    it "returns only one try for passports & residence cards" do
      document_variants1 = CensusApi::DocumentVariant.new(2, '1234')
      document_variants2 = CensusApi::DocumentVariant.new(3, '1234')

      expect(document_variants1.all).to eq(['1234'])
      expect(document_variants2.all).to eq(['1234'])
    end

    it 'takes only the last 8 digits for dnis and resicence cards' do
      document_variants = CensusApi::DocumentVariant.new(1, '543212345678')
      expect(document_variants.all).to eq(['12345678'])
    end

    it 'tries all the dni variants padding with zeroes' do
      document_variants1 = CensusApi::DocumentVariant.new(1, '0123456')
      document_variants2 = CensusApi::DocumentVariant.new(1, '00123456')

      expect(document_variants1.all).to eq(['123456', '0123456', '00123456'])
      expect(document_variants2.all).to eq(['123456', '0123456', '00123456'])
    end

    it 'adds upper and lowercase letter when the letter is present' do
      document_variants = CensusApi::DocumentVariant.new(1, '1234567A')
      expect(document_variants.all).to eq(['1234567', '01234567', '1234567a', '1234567A', '01234567a', '01234567A'])
    end

  end
end
