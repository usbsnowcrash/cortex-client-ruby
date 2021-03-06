require 'spec_helper'

RSpec.describe Cortex::Result do
  let(:result) { Cortex::Result.new('body', { 'X-Total' => '40', 'X-Page' => "1", 'X-Per-Page' => "10", 'X-Total-Pages' => '4', 'X-Next-Page' => '2', 'X-Prev-Page' => nil }, 200) }
  let(:failed) { Cortex::Result.new('failed body', {}, 403) }

  it 'should construct' do
    expect(result).to be_truthy
    expect(failed).to be_truthy
  end

  it 'should parse the headers' do
    expect(result.page).to eq 1
    expect(result.per_page).to eq 10
    expect(result.range).to eq "0-9"
  end

  it 'should provide is_error?' do
    expect(result.is_error?).to be_falsey
    expect(failed.is_error?).to be_truthy
  end

  it 'should parse errors properly' do
    expect(result.errors).to eq []
    expect(failed.errors).to eq ['failed body']
  end

  it 'should expose the contents' do
    expect(result.contents).to eq 'body'
    expect(failed.contents).to eq 'failed body'
  end

  it 'should expose the headers' do
    expect(result.raw_headers).to eq({ 'X-Total' => '40', 'X-Page' => "1", 'X-Per-Page' => "10", 'X-Total-Pages' => '4', 'X-Next-Page' => '2', 'X-Prev-Page' => nil })
    expect(failed.raw_headers).to eq({})
  end

  it 'should expose the http status' do
    expect(result.status).to eq 200
    expect(failed.status).to eq 403
  end

  describe '#total_pages' do
    it 'returns the value of "X-Total-Pages"' do
      expect(result.total_pages).to eq '4'
    end
  end

  describe '#next_page' do
    it 'returns_the_value of "X-Next-Page"' do
      expect(result.next_page).to eq '2'
    end
  end

  describe '#prev_page' do
    it 'returns nil when on the first page' do
      expect(result.prev_page).to be_nil
    end

    context 'on the 2nd page' do
      let(:result) { Cortex::Result.new('body', { 'X-Total' => '40', 'X-Page' => "2", 'X-Per-Page' => "10", 'X-Total-Pages' => '4', 'X-Next-Page' => '3', 'X-Prev-Page' => '1' }, 200) }
      it 'returns the value if "X-Prev-Page"' do
        expect(result.prev_page).to eq '1'
      end
    end
  end
end
