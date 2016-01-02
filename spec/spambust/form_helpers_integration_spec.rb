# form_helpers_integration_spec.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2016. All rights reserved
# License::   MIT
require File.expand_path "../spec_helper", File.dirname(__FILE__)
require File.expand_path "demo_app", File.dirname(__FILE__)

describe "Test application" do
  include Rack::Test::Methods

  let(:app)               { Spambust::TestApp }

  let(:user_digest)       { Digest::MD5.hexdigest("user") }
  let(:first_name_digest) { Digest::MD5.hexdigest("first_name") }
  let(:last_name_digest)  { Digest::MD5.hexdigest("last_name") }
  let(:email_digest)      { Digest::MD5.hexdigest("email") }

  describe "when loading a form" do
    it "contains hidden input fields" do
      get "/"

      last_response.body.must_include %Q(<input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[email]" size="40" />)
    end
  end

  describe "when posting a form" do
    describe "when hidden fields aren't filled" do
      it "is accepted" do
        params = {
          user_digest => {
            first_name_digest => "True first name",
            last_name_digest  => "True last name",
            email_digest      => "True email",
          },
          "user" => {
            "first_name" => "",
            "last_name"  => "",
            "email"      => "",
          }
        }

        post "/", params
        last_response.body.must_include %Q({"first_name"=>"True first name", "last_name"=>"True last name", "email"=>"True email"})
      end
    end

    describe "when hidden fields are filled" do
      it "is identified as fake" do
        params = {
          user_digest => {
            first_name_digest => "True first name",
            last_name_digest  => "True last name",
            email_digest      => "True email",
          },
          "user" => {
            "first_name" => "Fake first name",
            "last_name"  => "Fake last name",
            "email"      => "Fake email",
          }
        }

        post "/", params
        last_response.body.must_include "Faking is bad"
      end
    end
  end
end
