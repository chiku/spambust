# frozen_string_literal: true

# form_helpers_spec.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2020. All rights reserved
# License::   MIT

require 'digest/md5'

require_relative '../spec_helper'
require_relative '../../lib/spambust/form_helpers'

class TestApp
  include Spambust::FormHelpers
end

describe 'Spambust::FormHelpers' do
  subject { TestApp.new }

  let(:user_digest) { Digest::MD5.hexdigest('user') }
  let(:name_digest) { Digest::MD5.hexdigest('name') }
  let(:hiding) { 'position:absolute;top:-10000px;left:-10000px;' }

  describe '#input' do
    describe 'when type is not mentioned' do
      it "renders an input tag of type 'text'" do
        value(subject.input(%w[user name])).must_equal %(\
<input type="text" name="#{user_digest}[#{name_digest}]" />\
<input type="text" name="user[name]" style="#{hiding}" />)
      end
    end

    describe 'when type is mentioned' do
      it 'renders an input tag of specified type' do
        value(subject.input(%w[user name], type: 'password')).must_equal %(\
<input type="password" name="#{user_digest}[#{name_digest}]" />\
<input type="text" name="user[name]" style="#{hiding}" />)
      end
    end

    describe 'when CSS options are mentioned' do
      it 'renders the options' do
        value(subject.input(%w[user name], maxlength: '40')).must_equal %(\
<input maxlength="40" type="text" name="#{user_digest}[#{name_digest}]" />\
<input maxlength="40" type="text" name="user[name]" style="#{hiding}" />)
      end
    end

    describe "when CSS options include 'id'" do
      it "doesn't repeat the 'id'" do
        value(subject.input(%w[user name], id: 'name')).must_equal %(\
<input id="name" type="text" name="#{user_digest}[#{name_digest}]" />\
<input type="text" name="user[name]" style="#{hiding}" />)
      end
    end

    describe "when CSS options include 'class'" do
      it "doesn't repeat the 'class'" do
        value(subject.input(%w[user name], class: 'name')).must_equal %(\
<input class="name" type="text" name="#{user_digest}[#{name_digest}]" />\
<input type="text" name="user[name]" style="#{hiding}" />)
      end
    end

    describe "when CSS options include 'style'" do
      it "uses the 'style' to hide the fake input tag" do
        value(subject.input(%w[user name], style: 'padding-top: 2px;')).must_equal %(\
<input style="padding-top: 2px;" type="text" name="#{user_digest}[#{name_digest}]" />\
<input type="text" name="user[name]" style="#{hiding}" />)
      end
    end
  end

  describe '#submit' do
    describe 'when type is mentioned' do
      it "renders an input tag of specified 'submit" do
        tag = %(<input type="submit" value="Submit" />)
        value(subject.submit('Submit')).must_equal tag
      end
    end

    describe 'when CSS options are mentioned' do
      it 'renders the options' do
        value(subject.submit('Submit', id: 'submit', class: 'submit')).must_equal %(\
<input id="submit" class="submit" type="submit" value="Submit" />)
      end
    end
  end

  describe '#namify' do
    describe 'when size is one' do
      it 'is the word itself' do
        value(subject.namify(['user'])).must_equal 'user'
      end
    end

    describe 'when size is more than one' do
      it 'nests the items in successive square brackets' do
        value(subject.namify(%w[user name first])).must_equal 'user[name][first]'
      end
    end
  end

  describe '#decrypt' do
    it 'fetches the actual value of the lookup up key' do
      params = {
        'user' => { 'name' => 'spam value' },
        user_digest => { name_digest => 'true value' }
      }

      value(subject.decrypt('user', params)).must_equal('name' => 'true value')
    end

    describe "when lookup doesn't exist" do
      it 'is empty' do
        params = {
          'user' => { 'name' => 'spam value' },
          user_digest => { name_digest => 'true value' }
        }
        value(subject.decrypt('missing_user', params)).must_equal({})
      end
    end

    describe "when fake keys don't conform to the decrypted keys" do
      it 'populates the key with a nil value' do
        params = {
          'user' => { 'name' => 'spam value' },
          user_digest.succ => { name_digest => 'true value' }
        }
        value(subject.decrypt('user', params)).must_equal('name' => nil)
      end
    end
  end

  describe '#valid?' do
    describe 'when none of the paths under lookup are populated' do
      it 'is true' do
        params = {
          'user' => { 'name' => '' },
          user_digest => { name_digest => 'true value' }
        }

        value(subject.valid?('user', params)).must_equal true
      end
    end

    describe 'when one of the paths under lookup is populated' do
      it 'is false' do
        params = {
          'user' => { 'name' => 'spam value' },
          user_digest => { name_digest => 'true value' }
        }

        value(subject.valid?('user', params)).must_equal false
      end
    end

    describe "when lookup doesn't exist" do
      it 'is true' do
        params = {
          'user' => { 'name' => 'spam value' },
          user_digest => { name_digest => 'true value' }
        }

        value(subject.valid?('user_missing', params)).must_equal true
      end
    end
  end
end
