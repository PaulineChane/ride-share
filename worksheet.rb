# Pauline Chane (@PaulineChane on GitHub)
# Ada Developers Academy Cohort 14
# ride-share (worksheet.rb)
# 09/14/2020

# Response to Ride Share prompts in worksheet.rb, as denoted in the section under '------------- RESPONSE ----------------'.

########################################################
# Step 1: Establish the layers

# In this section of the file, as a series of comments,
# create a list of the layers you identify.
# Which layers are nested in each other?
# Which layers of data "have" within it a different layer?
# Which layers are "next" to each other?

# ------------- RESPONSE ----------------
# LAYER 1: drivers (by DRIVER_ID)-->
#          ex) drivers = {DR0000 => {RIDER_ID =>}, ...}
# LAYER 2: rides per driver-->
#          ex) drivers[:DRIVER_ID] = [{RIDE1...}, {RIDE2...}, {RIDE3....}]
# LAYER 3: rides and information about ride and riders (DATE, COST, RIDER_ID, RATING)
#          ex) drivers[:DRIVER_ID][INDEX] = {RIDER_ID => RD0000, DATE => "1st January 1970", COST => 0, RATING => 5}
########################################################
# Step 2: Assign a data structure to each layer

# Copy your list from above, and in this section
# determine what data structure each layer should have

# ------------- RESPONSE ----------------
# LAYER 1 (HASH): drivers (by DRIVER_ID)-->
#          ex) drivers = {DR0000 => {RIDER_ID =>}, ...}
# LAYER 2 (ARRAY): rides per driver-->
#          ex) drivers[:DRIVER_ID] = [{RIDE1...}, {RIDE2...}, {RIDE3....}]
# LAYER 3 (HASH): rides and information about ride and riders (DATE, COST, RIDER_ID, RATING)
#          ex) drivers[:DRIVER_ID][INDEX] = {RIDER_ID => RD0000, DATE => "1st January 1970", COST => 0, RATING => 5}

########################################################
# Step 3: Make the data structure!

# Setup the entire data structure:
# based off of the notes you have above, create the
# and manually write in data presented in rides.csv
# You should be copying and pasting the literal data
# into this data structure, such as "DR0004"
# and "3rd Feb 2016" and "RD0022"
#
# ------------- RESPONSE ----------------
drivers ={"DR0001" => [{"DATE" => "3rd Feb 2016", "COST" => 10,"RIDER_ID" => "RD0003", "RATING" => 3},{"DATE" => "3rd Feb 2016", "COST" => 30, "RIDER_ID" => "RD0015", "RATING" => 4},{"DATE" => "5th Feb 2016", "COST" => 45, "RIDER_ID" => "RD0003", "RATING" => 2}],
         "DR0002" => [{"DATE" => "3rd Feb 2016", "COST" => 25, "RIDER_ID" => "RD0073", "RATING" => 5},{"DATE" => "4th Feb 2016", "COST" => 15, "RIDER_ID" => "RD0013", "RATING" => 1},{"DATE" => "5th Feb 2016", "COST" => 35, "RIDER_ID" => "RD0066", "RATING" => 3}],
         "DR0003" => [{"DATE" => "4th Feb 2016", "COST" => 5,"RIDER_ID" => "RD0066", "RATING" => 5},{"DATE" => "5th Feb 2016", "COST" => 50, "RIDER_ID" => "RD0003", "RATING" => 2}],
         "DR0004" => [{"DATE" => "3rd Feb 2016", "COST" => 5,"RIDER_ID" => "RD0022", "RATING" => 5},{"DATE" => "4th Feb 2016", "COST" => 10, "RIDER_ID" => "RD0022", "RATING" => 4}, {"DATE" => "5th Feb 2016", "COST" => 20, "RIDER_ID" => "RD0073", "RATING" => 5}]}

########################################################
# Step 4: Total Driver's Earnings and Number of Rides

# Use an iteration blocks to print the following answers:
# - the number of rides each driver has given

# ------------- RESPONSE ----------------

puts "ADA RIDE SHARE DATA INFORMATION"

puts "\nThe number of rides each driver has given:"

# iterate through first layer to find the size of each hash, indicating # of rides
drivers.each do |driver, rides|
  puts "DRIVER #{driver}: #{rides.length} RIDES"
end



# - the total amount of money each driver has made

# ------------- RESPONSE ----------------

puts "\nThe total amount of money each driver has made:"

# creates a hash from the data structure where keys are the driver ID and values are calculate total money made from "COST" key per driver
total_money = drivers.map{|driver, rides|{driver.to_s => rides.inject(0){|total, ride| total += ride["COST"]}}}.reduce({}, :merge)

# prints results from new total_money hash
total_money.each do |driver, totals|
  puts "DRIVER #{driver}: $#{totals}"
end



# - the average rating for each driver

# ------------- RESPONSE ----------------

puts "\nAverage rating of each driver:"

# creates a hash from the data structure where keys are the driver ID and values are the calculated average ratings from "RATING" key for each driver
avg_rating = drivers.map{|driver, rides|
            {driver.to_s => rides.inject(0){|total, ride| total += ride["RATING"]} / rides.length.to_f}}.reduce({}, :merge)

# prints results from new avg_rating hash
avg_rating.each do |driver, rating|
  # diff string formatting to format float
  puts "DRIVER %s: %.1f/5" % [driver, rating]
end

# OPTIONAL: For each driver, on which day did they make the most money?

puts "\nDate that each driver made the most money in a single day:"
# outermost layer iteration - normally will avoid implementation comments but decided to do so because otherwise the expression looks messy
drivers.each do |driver, rides|
  # uses enum to map to a new hash.
  # first, each ride in rides has all key/value pairs removed except those with keys "COST" and "DATE" using slice
  # then, these keys are grouped by the value in their "DATE" key in a hash of array of hashes.
  # ex) {"1st January 1970" => [{"DATE" => "1st January 1970", "COST" => 30}, {"DATE" => "1st January 1970", "COST" => 5}], etc...}
  find_hi_earn_day = rides.map{|ride| ride.slice("DATE","COST")}.group_by{|new_ride| new_ride["DATE"]}

  # uses enum to re-map the above hash as follows:
  # re-maps key so that totals for all rides on the same day are added together serve as the sole value to the key (the date) using map and inject
  # this results in an array of hashes -- we don't want that, so reduce is used to merge array of hashes to single hash consisting of date/cost
  # ex) {"1st January 1970" => 35, etc...}
  # finally, max_by is used to pull the highest key value pair into an array, ex) ["1st January 1970", 35], prepend used to prepend driver ID
  find_hi_earn_day = find_hi_earn_day.map{|date, rides|
                    {date.to_s => rides.inject(0){|total, ride| total += ride["COST"]}}}.reduce({}, :merge).max_by{|date,total_cost| total_cost}.prepend(driver)

  # at LONG last, we can print the result
  puts "DRIVER %s: %s, $%d" % find_hi_earn_day
end

# - Which driver made the most money?

# ------------- RESPONSE ----------------
# using the total_money hash we created earlier on, we can pull this information!
# for a hash, max_by will return an array with the key value pair as [key, value]. store this in a variable
max_driver_money = total_money.max_by{|driver, money| money}
# print result
puts "\nDRIVER %s made the most money overall ($%d)." % max_driver_money



# - Which driver has the highest average rating?

# ------------- RESPONSE ----------------
# using the avg_rating hash we created earlier on, we can pull this information!
# for a hash, max_by will return an array with the key value pair as [key, value]. store this in a variable
max_driver_rating = avg_rating.max_by{|driver, rating| rating}
# print result
puts "\nDRIVER %s had the highest average rating overall (%.1f/5)." % max_driver_rating

