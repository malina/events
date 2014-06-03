require 'spec_helper'


describe User do
  describe "validations and simple properties" do
    describe "save should fail due to invalid password"  do
      let(:user) do
        FactoryGirl.build :user
      end
      
      it "should raise error when password is too short" do 
        user.password = user.password_confirmation = "abc"
        expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid,/Password is too short/)
      end

      it "should raise error when password doesn't match confirmation" do 
        user.password = "qwerty2013"
        user.password_confirmation = "qwerty2014"
        expect {user.save!}.to raise_error(ActiveRecord::RecordInvalid,/Password confirmation doesn't match Password/)
      end

    end


    describe "email operations" do  
      let(:user){ FactoryGirl.build :user }

      describe "email address with mixed case" do
        let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
        
        it "should be saved as all lower-case" do
          user.email = mixed_case_email
          user.save
          expect(user.reload.email).to eq mixed_case_email.downcase
        end
      end

    end
  end
end