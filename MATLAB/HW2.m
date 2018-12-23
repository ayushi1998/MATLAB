% Ans B)
z_scores_values_array=[4.938 22.635 4.418 10.164 3.153 2.195 4.571 5.837 2.449 6.877 2.796 4.484 4.484 2.227 9.044 64.752 64.752 64.752 64.752 3.211];
histogram(z_scores_values_array,30) % Plotting Histogram

std(z_scores_values_array)   % Standard Deviation of the z_score array.
% Standard Deviation: 24.5876

mean(z_scores_values_array)  % Mean of the array.[20 values]    
% Mean Value: 17.6246

% Ans C)

copy_number=[6 13 11 16 6 15 11 9 6 9 5 8 7 6 16 10 43 19 47 5];
z_scores_values_array=[4.938 22.635 4.418 10.164 3.153 2.195 4.571 5.837 2.449 6.877 2.796 4.484 4.484 2.227 9.044 64.752 64.752 64.752 64.752 3.211];

% Statistical Correalation between copy	 number	 variation	(cnv)	 and	 gene expression	levels	for	Bcl2.	

corrcoef(z_scores_values_array,copy_number)



