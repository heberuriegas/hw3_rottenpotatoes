# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
    Movie.where(movie).first_or_create
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  temp = nil
  temp2=nil
  page.all('#movielist tr').each do |t|
    node = t.native.xpath('td/text()').first.text
    
    temp = node if node == e1
    temp2 = node if node == e2 && !temp.nil?
  end
  
  if current_path.respond_to? :should
    temp2.should != nil
  else
    assert_not_equal temp2, nil
  end
  
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  prefix = 'ratings_'
  
  if uncheck
    rating_list.split(',').each{|rating| step %Q{I uncheck "#{prefix+rating.strip}"}}
  else
    #rating_list.split(',').each{|rating| check prefix+rating.strip}
    rating_list.split(',').each{|rating| step %Q{I check "#{prefix+rating.strip}"}}
  end  
end

Then /I should see all of the movies/ do
  if current_path.respond_to? :should
    page.all('#movielist tr').count.should == (Movie.all.count)
  else
    assert_equal   page.all('#movielist tr').count, (Movie.all.count)
  end
end

Then /I should not see any movie/ do
  if current_path.respond_to? :should
    page.all('#movielist tr').count.should == 0
  else
    assert_equal page.all('#movielist tr').count, 0
  end
end
