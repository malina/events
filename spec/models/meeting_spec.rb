require 'spec_helper'

describe Meeting do
  
  describe "add/remove/edit participants" do

    let(:meeting) { FactoryGirl.create :meeting }

    describe "add user" do
      it "should create assignment" do
        user = FactoryGirl.create(:user, name: "John")
        Assignment.create(user: user, meeting: meeting, role: 1)
        expect(meeting.participants.first.role).to be == 1
        expect(meeting.participants.first.name).to eq("John")
      end

      it "should add user with role" do
        user = FactoryGirl.create(:user, name: "John")
        meeting.add_user(user,1)
        meeting.save
        meeting.reload
        expect(meeting.participants.first.role).to be == 1
        expect(meeting.participants.first.name).to eq("John")
      end

      it "should add multiple users" do
        meeting.add_user(FactoryGirl.create(:user, name: "John"),1)
        meeting.add_user(FactoryGirl.create(:user, name: "Vasya"))
        meeting.add_user(FactoryGirl.create(:user, name: "Max"))
        meeting.save
        meeting.reload
        expect(meeting.participants.length).to eq(3)
        expect(meeting.presenters.first.name).to eq("John")
      end


      it "should not add a user twice" do
        user = FactoryGirl.create(:user, name: "John")
        meeting.add_user(user,1)
        meeting.save
        expect{meeting.add_user!(user,1)}.to raise_error(ActiveRecord::RecordNotUnique)
      end


      it "should not add multiple users if there are duplicates" do
        user = FactoryGirl.create(:user, name: "John")
        meeting.add_user(user,1)
        meeting.add_user(FactoryGirl.create(:user, name: "Vasya"))
        meeting.add_user(FactoryGirl.create(:user, name: "Max"))
        meeting.add_user(user)
        expect{meeting.save}.to raise_error(ActiveRecord::RecordNotUnique)
        meeting.reload
        expect(meeting.participants.length).to eq(0)
      end

    end

  end
end
