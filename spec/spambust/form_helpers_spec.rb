require "digest/md5"

require File.expand_path "../spec_helper", File.dirname(__FILE__)
require File.expand_path "../../lib/spambust/form_helpers", File.dirname(__FILE__)

class TestApp
  include Spambust::FormHelpers
end

describe "Bustspam::FormHelpers" do
  subject { TestApp.new }
  let(:user_md5) { Digest::MD5.hexdigest("user") }
  let(:name_md5) { Digest::MD5.hexdigest("name") }

  describe "#input" do
    describe "when type is not mentioned" do
      it "renders an input tag of type 'text'" do
        subject.input(["user", "name"]).must_equal %Q(<input type="text" name="#{user_md5}[#{name_md5}]" /><input type="hidden" name="user[name]" />)
      end
    end

    describe "when type is mentioned" do
      it "renders an input tag of specified type" do
        subject.input(["user", "name"], :type => "password").must_equal %Q(<input type="password" name="#{user_md5}[#{name_md5}]" /><input type="hidden" name="user[name]" />)
      end
    end

    describe "when other options are mentioned" do
      it "renders the options" do
        subject.input(["user", "name"], :id => "name", :class => "name").must_equal %Q(<input type="text" name="#{user_md5}[#{name_md5}]" id="name" class="name" /><input type="hidden" name="user[name]" class="name" />)
      end
    end
  end

  describe "#submit" do
    describe "when type is mentioned" do
      it "renders an input tag of specified 'submit" do
        subject.submit("Submit").must_equal '<input type="submit" value="Submit" />'
      end
    end

    describe "when other options are mentioned" do
      it "renders the options" do
        subject.submit("Submit", :id => "submit", :class => "submit").must_equal '<input type="submit" value="Submit" id="submit" class="submit" />'
      end
    end
  end
end
