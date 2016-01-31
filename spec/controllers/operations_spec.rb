require 'spec_integration_helper'

RSpec.describe "UdSync/Operations", type: :request do

  before do
  end

  describe "GET /ud_sync/operations" do
    it "signs the user in" do
      User.create(
        name: 'alex'
      )

      #UdSync::Operation.create(
      #  name: 'save',
      #  record_id: '1',
      #  entity_name: 'user'
      #)
      get "/ud_sync/operations", nil #, oauth_headers(user)


      ap response.body
      ap json_response
      #expect(status_code).to eq(200)
      #expect(json_response).to eq({
      #  data: {
      #  }
      #})
    end
  end
end
