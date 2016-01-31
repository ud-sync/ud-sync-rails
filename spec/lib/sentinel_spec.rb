require 'spec_integration_helper'

class DefaultDummyModel < ActiveRecord::Base
  self.table_name = "users"

  ud_sync
end

class CustomDummyModel < ActiveRecord::Base
  self.table_name = "users"

  ud_sync entity: 'User', id: :uuid
end

class UserScopedArticle < ActiveRecord::Base
  self.table_name = "articles"

  belongs_to :user, foreign_key: :author_id, class_name: 'CustomDummyModel'
  ud_sync entity: 'Article', id: :uuid, owner: :user
end

describe UdSync::Sentinel do
  context 'defaults' do
    it 'generates a new operation' do

      expect(UdSync::Operation.count).to eq 0
      new_user = DefaultDummyModel.create(name: 'alex', uuid: '123')
      expect(UdSync::Operation.count).to eq 1

      new_operation = UdSync::Operation.last
      expect(new_operation.name).to        eq 'save'
      expect(new_operation.record_id).to   eq new_user.id.to_s
      expect(new_operation.entity_name).to eq 'DefaultDummyModel'
    end
  end

  context 'custom' do
    let(:new_user) { CustomDummyModel.create(name: 'alex', uuid: '123') }
    let(:user_id) { new_user.id }

    before do
      expect(UdSync::Operation.count).to eq 0
      new_user
      user_id
      expect(UdSync::Operation.count).to eq 1
    end

    context 'saving' do
      subject { UdSync::Operation.last }

      it 'saves operation name' do
        expect(subject.name).to eq 'save'
      end

      it 'saves record id' do
        expect(subject.record_id).to eq new_user.id.to_s
      end

      it 'saves external id' do
        expect(subject.external_id).to eq '123'
      end

      it 'saves operation entity' do
        expect(subject.entity_name).to eq 'User'
      end

      it 'has no owner' do
        expect(subject.owner_id).to eq nil
      end
    end

    context 'delete' do
      subject { UdSync::Operation.last }

      before do
        CustomDummyModel.last.destroy
        expect(UdSync::Operation.count).to eq 2
        user_id
      end

      it 'saves operation name' do
        expect(subject.name).to eq 'delete'
      end

      it 'saves record id' do
        expect(subject.record_id).to eq user_id.to_s
      end

      it 'saves external id' do
        expect(subject.external_id).to eq '123'
      end

      it 'saves operation entity' do
        expect(subject.entity_name).to eq 'User'
      end

      it 'has no owner' do
        expect(subject.owner_id).to eq nil
      end
    end
  end

  context 'scoped article' do
    let(:user)     { CustomDummyModel.create(name: 'alex', uuid: '123') }
    let(:article1) { UserScopedArticle.create(title: '2nd post', uuid: 'eeee') }
    let(:article2) { UserScopedArticle.create(title: 'my post', uuid: 'abcd', user: user) }

    before do
      expect(UdSync::Operation.count).to eq 0
      article1
      article2
      expect(UdSync::Operation.count).to eq 3
    end

    context 'saving' do
      subject { UdSync::Operation.find_by_record_id(article2.id) }

      it 'saves operation name' do
        expect(subject.name).to eq 'save'
      end

      it 'saves record id' do
        expect(subject.record_id).to eq article2.id.to_s
      end

      it 'saves external id' do
        expect(subject.external_id).to eq 'abcd'
      end

      it 'saves operation entity' do
        expect(subject.entity_name).to eq 'Article'
      end

      it 'has an owner' do
        expect(article2.author_id).to eq user.id.to_s
        expect(subject.owner_id).to eq user.id.to_s
      end
    end
  end
end
