num_round = size(rec_vec, 2); 
rec_ctrain = cell(num_round, 1); 
rec_curj = cell(num_round, 1); 
exter_h = rec_vec; 

train_dat = struct('round', num_round, 'epoch', num_epoch, 'j_mat', j_mat,...
    'h_vec', h_vec, 'decayp', 0.3,...
    'stepsz', stepsz, 'counter', 1, 'exter_h', exter_h,...
    'samplingsz', samplingsz, 'samplingmix', samplingmix, 'rec_gap', 50,...
    'lam_l2', 0);
    
rec_all_corr = zeros(num_spin, num_spin, 1); 
for ii = 1: num_round
    rec_sample = make_spin_sample(j_mat, h_vec + exter_h(:, ii), sample_size, mixing_time);
    %[corr_sample, mean_sample] = exact_moments(j_mat, h_vec + rec_bestdir(:, ii) * rec_bestinten(ii));
    rec_all_corr(:, :, ii) = (rec_sample * rec_sample') / sample_size;
    
    train_dat.corrs = rec_all_corr; 
    train_dat.round = ii; 
    
    [cur_j, cur_h, datf] = learn_parameters(zeros(num_spin), zeros(num_spin, 1), train_dat);
    rec_ctrain{ii} = datf; 
    rec_curj{ii} = cur_j; 
end

