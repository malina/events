require 'spec_helper'

describe Api::MeetingsController do

  Api::ApplicationController.skip_before_action :verify_authenticity_token

  render_views 

  before(:all) do
    @user = FactoryGirl.create(:user,:email => "meeting_api@spec.com", :password => "secret",:password_confirmation => "secret")
  end

  after(:all) do
    @user.destroy
  end


  describe "meetings actions" do

    before(:each) do
      login_user @user
    end

    after(:each) do
      logout_user
    end

    it "should respond with empty list" do
      get :index, format: :json
      expect(response.body).to have_json_size(0).at_path("meetings")
      expect(response.body).to include_json(pagination(1,0))
    end


    it "should respond with meetings list" do
      meeting = FactoryGirl.create(:meeting)
      meeting.add_user! @user
      get :index, format: :json
      expect(response.body).to have_json_size(1).at_path("meetings")
      expect(response.body).to include_json pagination(1,1)
    end


    
    describe "crud operations" do

      describe "show meeting" do

        it "should respond with meeting info" do

          meeting = FactoryGirl.create :meeting, name: "Gut Show"

          get :show, format: :json, id: meeting.id
          expect(response.status).to eq(200)
          
          info = parse_json(response.body,"meeting")
          expect(info["name"]).to eq("Gut Show")
        end
      end


      describe "create meeting" do
        it "should respond with error when incorrect parameters" do
          post :create, format: :json, meeting: {:name => 'test'}
          expect(response.status).to eq(403)
        end

        it "should respond with meeting info" do
          post :create, format: :json, meeting: {:name => 'test', :started_at_date => '2014-03-01', :started_at_time => '10:00 pm'}
          expect(response.status).to eq(200)
          info = parse_json(response.body,"meeting")
          expect(info["start_time"]).to eq("01 March 10:00 pm")
        end

        it "should add participants on create" do
          user1 = FactoryGirl.create :user
          user2 = FactoryGirl.create :user, name: "John"

          post :create, format: :json, meeting: {:name => 'test upd', :started_at_date => '2014-03-01', :started_at_time => '10:00 pm'}, participants: [{:id => user1.id},{:id => user2.id, :role => 1}]
          expect(response).to be_success
          info = parse_json(response.body,"meeting")

          meeting = Meeting.find info["id"]
          expect(meeting.participants.length).to eq(2)
          expect(meeting.presenters.first.name).to eq("John")
        end


         it "should not create meeting if adding participants failed" do
          user1 = FactoryGirl.create :user
          user2 = FactoryGirl.create :user, name: "John"

          Api::MeetingsController.any_instance.stub(:create_participants) do
            raise "intentional error"
          end

          expect{post :create, format: :json, meeting: {:name => 'NoSuchMeeting!', :started_at_date => '2014-03-01', :started_at_time => '10:00 pm'}, participants: [{:id => user1.id},{:id => user2.id, :role => 1}]}.to raise_error
          
          meeting = Meeting.find_by_name 'NoSuchMeeting!'
          expect(meeting).to be_nil
        end

        it "should remove participants" do
          pending
        end

        it "should update participants" do
          pending
        end

        it "should add+remove+update participants" do
          pending
        end
      end 
    end
  end
end