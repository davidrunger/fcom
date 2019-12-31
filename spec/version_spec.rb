# frozen_string_literal: true

RSpec.describe 'Fcom::VERSION' do
  it 'is not nil' do
    expect(Fcom::VERSION).not_to eq(nil)
  end
end
