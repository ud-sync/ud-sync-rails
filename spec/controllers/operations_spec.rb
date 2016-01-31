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
            'id' => '1',
            'name' => 'save',
            'record_id' => user.id.to_s,
            'entity' => 'User',
            'date' => UdSync::Operation.first.created_at.iso8601,
          }, {
            'id' => '2',
            'name' => 'save',
            'record_id' => 'external_id',
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
              'id' => '2',
              'name' => 'save',
              'record_id' => 'external-2',
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

  describe "GET /ud_sync/operations?since=2016-01-01T10:10:10Z" do
    context 'no user scope' do
      it "signs the user in" do
        UdSync::Operation.create(
          name: 'save',
          record_id: 'record-1',
          external_id: 'external-1',
          entity_name: 'Post',
          created_at: DateTime.new(2015, 02, 02, 02, 02, 02).utc
        )

        newer = UdSync::Operation.create(
          name: 'save',
          record_id: 'record-2',
          external_id: 'external-2',
          entity_name: 'Post',
          created_at: DateTime.new(2016, 02, 02, 02, 02, 02).utc
        )

        UdSync::Operation.create(
          name: 'save',
          record_id: 'record-3',
          external_id: 'external-3',
          entity_name: 'Post',
          created_at: DateTime.new(2015, 12, 30, 23, 59, 59).utc
        )
        get "/ud_sync/operations?since=2016-01-01T10:10:10Z", nil

        expect(response.code).to eq('200')
        expect(json_response).to eq({
          'operations' => [{
            'id' => newer.id.to_s,
            'name' => 'save',
            'record_id' => 'external-2',
            'entity' => 'Post',
            'date' => '2016-02-02T02:02:02Z',
          }]
        })
      end
    end
  end
end
