require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^(?:|I )am on (.+)$/ do |page_name|
	visit path_to(page_name)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
	current_path = URI.parse(current_url).path
	if current_path.respond_to? :should
		current_path.should == path_to(page_name)
	else
		assert_equal path_to(page_name), current_path
	end
end

Then /^I should see the following table:$/ do |table|
	max_width = table.raw.first.size + 1
	table_content = page.all('table tr').map do |row|
		row.all('td,th').map(&:text).first(max_width).map(&:strip)
	end
	table.diff! Cucumber::Ast::Table.new(table_content)
end

Then /^there should be (\d+) (?:"([^"]*)" )?(.*)s?$/ do |count,bool,model|
	if bool
		Object.const_get(model.classify).where(bool.to_sym => true).count.should == count.to_i
	else
		Object.const_get(model.classify).all.count.should == count.to_i
	end
	instance_variable_set("@#{model}", Object.const_get(model.classify).first) if count.to_i == 1
end

Given /^there are no "([^"]*)"$/ do |params|
	params.singularize.titleize.constantize.delete_all
end

Then /^I should see the following table:$/ do |table|
	max_width = table.raw.first.size + 1
	table_content = page.all('table tr').map do |row|
		row.all('td,th').map(&:text).first(max_width).map(&:strip)
	end
	table.diff! Cucumber::Ast::Table.new(table_content)
end
