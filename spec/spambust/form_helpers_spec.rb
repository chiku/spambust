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
        subject.input(["user", "name"]).must_equal %Q(<input type="text" name="#{user_md5}[#{name_md5}]" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" />)
      end
    end

    describe "when type is mentioned" do
      it "renders an input tag of specified type" do
        subject.input(["user", "name"], :type => "password").must_equal %Q(<input type="password" name="#{user_md5}[#{name_md5}]" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" />)
      end
    end

    describe "when other options are mentioned" do
      it "renders the options" do
        subject.input(["user", "name"], :class => "name").must_equal %Q(<input type="text" name="#{user_md5}[#{name_md5}]" class="name" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" class="name" />)
      end
    end

    describe "when other options include 'id'" do
      it "doesn't repeat the 'id'" do
        subject.input(["user", "name"], :id => "name").must_equal %Q(<input type="text" name="#{user_md5}[#{name_md5}]" id="name" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" />)
      end
    end
  end

  describe "#submit" do
    describe "when type is mentioned" do
      it "renders an input tag of specified 'submit" do
        subject.submit("Submit").must_equal %Q(<input type="submit" value="Submit" />)
      end
    end

    describe "when other options are mentioned" do
      it "renders the options" do
        subject.submit("Submit", :id => "submit", :class => "submit").must_equal %Q(<input type="submit" value="Submit" id="submit" class="submit" />)
      end
    end
  end

  describe "#namify" do
    describe "when size is one" do
      it "is the word itself" do
        subject.namify(["user"]).must_equal "user"
      end
    end

    describe "when size is more than one" do
      it "nests the items in successive square brackets" do
        subject.namify(["user", "name", "first"]).must_equal "user[name][first]"
      end
    end
  end

  describe "#decrypt" do
    it "pulls the values corresponding to decrypted the keys under the lookup" do
      params = {
        "user" => { "name" => "spam value"},
        user_md5 => { name_md5 => "true value" }
      }

      subject.decrypt("user", params).must_equal("name" => "true value")
    end

    describe "when lookup doesn't exist" do
      it "is empty" do
        params = {
          "user" => { "name" => "spam value"},
          user_md5 => { name_md5 => "true value" }
        }
        subject.decrypt("missing_user", params).must_equal({})
      end
    end

    describe "when fake keys don't conform to the decrypted keys" do
      it "populates the key with a nil value" do
        params = {
          "user" => { "name" => "spam value"},
          user_md5.succ => { name_md5 => "true value" }
        }
        subject.decrypt("user", params).must_equal({"name" => nil})
      end
    end
  end

  describe "#valid?" do
    describe "when none of the paths under lookup are populated" do
      it "is true" do
        params = {
          "user" => { "name" => ""},
          user_md5 => { name_md5 => "true value" }
        }

        subject.valid?("user", params).must_equal true
      end
    end

    describe "when one of the paths under lookup is populated" do
      it "is false" do
        params = {
          "user" => { "name" => "spam value"},
          user_md5 => { name_md5 => "true value" }
        }

        subject.valid?("user", params).must_equal false
      end
    end

    describe "when lookup doesn't exist" do
      it "is true" do
        params = {
          "user" => { "name" => "spam value"},
          user_md5 => { name_md5 => "true value" }
        }

        subject.valid?("user_missing", params).must_equal true
      end
    end
  end
end
