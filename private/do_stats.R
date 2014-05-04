# Run from the command line as `Rscript do_stats.R`
# Make sure you are in the appropriate directory (../data)

library('rjson');

data = fromJSON(file='data/cogsci_data_2014-05-03T20:08:18.157774.json');

response_array = array(0, c(length(data)/24, 2), dimnames = list(NULL, c('good_chord_times', 'bad_chord_times')));

for (i in data) {
  if (i[['chord']] == 'good') {
    response_array[i[['user_id']] + 1, 1] = response_array[i[['user_id']] + 1, 1] + i[['response_time']];
  }
  else if (i[['chord']] == 'bad') {
    response_array[i[['user_id']] + 1, 2] = response_array[i[['user_id']] + 1, 2] + i[['response_time']];
  }
}

response_array = response_array / 12; # Take average response times

diffs = response_array[,2] - response_array[,1]; # bad_chord - good_chord response time response time

# Generate a histogram of the data - should be normally distributed if the t-test is to hold at low sample sizes
hist(diffs);

# State the hypotheses
print('H_0: M = 0');
print('H_a: M > 0');

# Perform a matched pairs analysis on the data
t.test(response_array[,'bad_chord_times'], response_array[,'good_chord_times'], alt="two.sided", paired=TRUE);