# Run from the command line as `Rscript do_stats.R`
# Make sure you are in the appropriate directory (../data)

library('rjson');

data = fromJSON(file='data/cogsci_data_2014-05-03T20:08:18.157774.json');

response_times_per_user = array(0, c(length(data)/24, 2), dimnames = list(NULL, c('good_chord_times', 'bad_chord_times')));
response_times_per_card = array(0, c(12, 2), dimnames = list(NULL, c('good_chord_times', 'bad_chord_times')));
errors_per_user = array(0, c(length(data)/24, 2), dimnames = list(NULL, c('good_chord_errors', 'bad_chord_errors')));
errors_per_card = array(0, c(12, 2), dimnames = list(NULL, c('good_chord_errors', 'bad_chord_errors')));

for (i in data) {
  if (i[['chord']] == 'good') {
    response_times_per_user[i[['user_id']] + 1, 1] = response_times_per_user[i[['user_id']] + 1, 1] + i[['response_time']];
    response_times_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 1] = response_times_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 1] + i[['response_time']];

    if (i[['is_correct']] == FALSE) {
      errors_per_user[i[['user_id']] + 1, 1] = errors_per_user[i[['user_id']] + 1, 1] + 1;
      errors_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 1] = errors_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 1] + 1;
    }
  }
  else if (i[['chord']] == 'bad') {
    response_times_per_user[i[['user_id']] + 1, 2] = response_times_per_user[i[['user_id']] + 1, 2] + i[['response_time']];
    response_times_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 2] = response_times_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 2] + i[['response_time']];

    if (i[['is_correct']] == FALSE) {
      errors_per_user[i[['user_id']] + 1, 2] = errors_per_user[i[['user_id']] + 1, 2] + 1;
      errors_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 2] = errors_per_card[as.numeric(gsub("\\D", "", i[['card_id']])), 2] + 1;
    }
  }
}

# Remove rows with user_id's 17 and 18 due to technical failures with those users
# (should remove from per_card data too, but it's going to be insigificant no matter what, and I hate writing complicated R code)
response_times_per_user = response_times_per_user[-(18:19),];
errors_per_user = errors_per_user[-(18:19),];

response_times_per_user = response_times_per_user / 12; # Take average response times for each user for ALL cards
response_times_per_card = response_times_per_card / (length(data) / 24); # Take average times for each card for ALL users


# Generate a histogram of the data - should be normally distributed if the t-test is to hold at low sample sizes
hist(response_times_per_user[,2] - response_times_per_user[,1]); # bad_chord - good_chord
hist(response_times_per_card[,2] - response_times_per_card[,1]); # bad_chord - good_chord
hist(errors_per_user[,2] - errors_per_user[,1]);# bad_chord - good_chord
hist(errors_per_card[,2] - errors_per_card[,1]); # bad_chord - good_chord

# Perform a matched pairs analysis on the data
t.test(response_times_per_user[,'bad_chord_times'], response_times_per_user[,'good_chord_times'], alt="greater", paired=TRUE);
t.test(response_times_per_card[,'bad_chord_times'], response_times_per_card[,'good_chord_times'], alt="greater", paired=TRUE);
t.test(errors_per_user[,'bad_chord_errors'], errors_per_user[,'good_chord_errors'], alt="greater", paired=TRUE);
t.test(errors_per_card[,'bad_chord_errors'], errors_per_card[,'good_chord_errors'], alt="greater", paired=TRUE);
