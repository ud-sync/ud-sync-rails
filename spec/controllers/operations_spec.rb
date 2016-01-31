require 'spec_integration_helper'

RSpec.describe "UdSync/Operations", type: :request do
  describe "GET /ud_sync/operations" do
    context 'no user scope' do
      it "signs the user in" do
        user = User.create(
          name: 'alex'
        )

        UdSync::Operation.create(
          name: 'save',
          record_id: 'record_id',
          external_id: 'external_id',
          entity_name: 'Post'
        )
        get "/ud_sync/operations", nil

        expect(response.code).to eq('200')
        expect(json_response).to eq({
          'operations' => [{
            'id' => 1,
            'name' => 'save',
            'record_id' => user.id.to_s,
            'entity' => 'User',
            'date' => UdSync::Operation.first.created_at.iso8601,
          }, {
            'id' => 2,
            'name' => 'save',
            'record_id' => 'record_id',
            'entity' => 'Post',
            'date' => UdSync::Operation.last.created_at.iso8601,
          }]
        })
      end
    end
  end
end
