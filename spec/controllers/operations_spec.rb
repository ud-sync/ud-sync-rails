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

    context 'with user scope' do
      let(:current_user) { double(User, id: 2) }

      before do
        UdSync::Operation.create(
          name: 'save',
          record_id: 'record-1',
          external_id: 'external-1',
          entity_name: 'Post',
          owner_id: 1
        )
        UdSync::Operation.create(
          name: 'save',
          record_id: 'record-2',
          external_id: 'external-2',
          entity_name: 'Post',
          owner_id: 2
        )
      end

      context 'there is a logged in user' do
        before do
          allow_any_instance_of(ApplicationController)
            .to receive(:current_user)
            .and_return(current_user)
        end

        it "signs the user in" do
          get "/ud_sync/operations", nil

          expect(response.code).to eq('200')
          expect(json_response).to eq({
            'operations' => [{
              'id' => 2,
              'name' => 'save',
              'record_id' => 'record-2',
              'entity' => 'Post',
              'date' => UdSync::Operation.last.created_at.iso8601,
            }]
          })
        end
      end

      context 'there is NO logged in user' do
        before do
          allow_any_instance_of(ApplicationController)
            .to receive(:current_user)
            .and_return(nil)
        end

        it "signs the user in" do
          get "/ud_sync/operations", nil

          expect(response.code).to eq('401')
        end
      end
    end
  end
end
