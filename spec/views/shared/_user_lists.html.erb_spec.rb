#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../views_helper')

describe "/shared/_user_lists" do
  it "should render as a course" do
    assigns[:context] = course
    render :partial => "shared/user_lists"
  end

  it "should render as a root account" do
    assigns[:context] = Account.default
    render :partial => "shared/user_lists"
  end

  it "should render as a sub account" do
    assigns[:context] = Account.default.sub_accounts.create!
    render :partial => "shared/user_lists"
  end

  it "should render as a root account with customized login handle" do
    Account.default.account_authorization_configs.create!(:login_handle_name => 'Login')
    assigns[:context] = Account.default
    render :partial => "shared/user_lists"
  end

  it "should default search existing users to open registration setting (true)" do
    account = Account.default
    account.add_user(user)
    assigns[:context] = account
    assigns[:current_user] = @user
    render :partial => "shared/user_lists"
    partial = Nokogiri::HTML('<document>' + response.body + '</document>')
    partial.at_css('input[name="only_search_existing_users"]')['checked'].should == 'checked'
  end

  it "should default search existing users to open registration setting (false)" do
    account = Account.default
    account.add_user(user)
    assigns[:context] = account
    assigns[:current_user] = @user
    account.settings = { :open_registration => true }
    account.save!
    render :partial => "shared/user_lists"
    partial = Nokogiri::HTML('<document>' + response.body + '</document>')
    partial.at_css('input[name="only_search_existing_users"]')['checked'].should be_blank
  end
end
