function classify_BOSSbase(cover, stego, seed_value)

names = intersect(cover.names,stego.names);
names = sort(names);

cover_names = cover.names(ismember(cover.names,names));
[cover_names,ix] = sort(cover_names);
C = cover.F(ismember(cover.names,names),:);
C = C(ix,:);

stego_names = stego.names(ismember(stego.names,names));
[stego_names,ix] = sort(stego_names);
S = stego.F(ismember(stego.names,names),:);
S = S(ix,:);

RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed_value));

random_permutation = randperm(size(C,1));
training_set = random_permutation(1:round(size(C,1)/2));
testing_set = random_permutation(round(size(C,1)/2)+1:end);
training_names = names(training_set);
testing_names = names(testing_set);

TRN_cover = C(training_set,:);
TRN_stego = S(training_set,:);

TST_cover = C(testing_set,:);
TST_stego = S(testing_set,:);

[trained_ensemble,results] = ensemble_training(TRN_cover,TRN_stego);

test_results_cover = ensemble_testing(TST_cover,trained_ensemble);
test_results_stego = ensemble_testing(TST_stego,trained_ensemble);

false_alarms = sum(test_results_cover.predictions~=-1);
missed_detections = sum(test_results_stego.predictions~=+1);
num_testing_samples = size(TST_cover,1)+size(TST_stego,1);
testing_error = (false_alarms + missed_detections)/num_testing_samples;
fprintf('Testing error: %.4f\n',testing_error);

settings = struct('d_sub',300);
[~,results] = ensemble_training(TRN_cover,TRN_stego,settings);

settings = struct('d_sub',300,'L',30);
[~,results] = ensemble_training(TRN_cover,TRN_stego,settings);

settings = struct('d_sub',300,'L',30);
OOB = zeros(1,10);
for i=1:10
    [~,results] = ensemble_training(TRN_cover,TRN_stego,settings);
    OOB(i) = results.optimal_OOB;
end
fprintf('# -------------------------\n');
fprintf('Average OOB error = %.5f (+/- %.5f)\n',mean(OOB),std(OOB));

settings = struct('d_sub',300,'L',30,'seed_subspaces',5,'seed_bootstrap',73);
[~,results] = ensemble_training(TRN_cover,TRN_stego,settings);

settings = struct('d_sub',300,'L',30,'verbose',0);
[~,results] = ensemble_training(TRN_cover,TRN_stego,settings);
fprintf('OOB error = %.4f\n',results.optimal_OOB);

settings = struct('d_sub',300,'L',30,'verbose',2);
[~,results] = ensemble_training(TRN_cover,TRN_stego,settings);

testing_errors = zeros(1,10);
settings = struct('d_sub',300,'verbose',2);
for seed = 1:10
    RandStream.setGlobalStream(RandStream('mt19937ar','Seed',seed));
    random_permutation = randperm(size(C,1));
    training_set = random_permutation(1:round(size(C,1)/2));
    testing_set = random_permutation(round(size(C,1)/2)+1:end);
    TRN_cover = C(training_set,:);
    TRN_stego = S(training_set,:);
    TST_cover = C(testing_set,:);
    TST_stego = S(testing_set,:);
    [trained_ensemble,results] = ensemble_training(TRN_cover,TRN_stego,settings);
    test_results_cover = ensemble_testing(TST_cover,trained_ensemble);
    test_results_stego = ensemble_testing(TST_stego,trained_ensemble);
    false_alarms = sum(test_results_cover.predictions~=-1);
    missed_detections = sum(test_results_stego.predictions~=+1);
    num_testing_samples = size(TST_cover,1)+size(TST_stego,1);
    testing_errors(seed) = (false_alarms + missed_detections)/num_testing_samples;
    fprintf('Testing error %i: %.4f\n',seed,testing_errors(seed));
end
fprintf('---\nAverage testing error over 10 splits: %.4f (+/- %.4f)\n',mean(testing_errors),std(testing_errors));
