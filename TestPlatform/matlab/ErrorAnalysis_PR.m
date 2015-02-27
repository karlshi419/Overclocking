% error analysis: error expectation
clear;
clc;

img=strcat('tiffany');

disp('Data Processing Starts...')
WL = 8;
frac_bits = WL;
Permutation = 1300;

freq_valid=[200:50:400,420:20:500,510:10:720];

for i=1:1:32
    freq = freq_valid(1,i);
    fn=strcat('./data_preprocess_python/',img,'_data_',num2str(freq),'_MHz.txt');   
    %disp('Read Test file: data_', num2str(freq), '_MHz.txt --done')
    temp_data=DataProcessing_PR(fn,Permutation+12, frac_bits)';
    sum_dec(freq/10,:)=temp_data(1,13:Permutation+12);
    %disp('Process Test file for frequency:', num2str(freq), '--done')
    
    error(freq/10,:) = abs(sum_dec(20,:))-abs(sum_dec(freq/10,:));
    error2(freq/10,:)= sum_dec(20,:) - sum_dec(freq/10,:);
    exp(freq/10,:)   = mean(abs(error(freq/10,:)));
    exp2(freq/10,:)  = mean(abs(error2(freq/10,:)));
    exp3(freq/10,:)  = abs(mean(error2(freq/10,:)));
    
    MRE(:,freq/10)   = exp(freq/10,:)./mean(abs(sum_dec(20,:)))*100;
    MRE2(:,freq/10)  = exp2(freq/10,:)./mean(abs(sum_dec(20,:)))*100;
    MRE3(:,freq/10)  = exp3(freq/10,:)./mean(abs(sum_dec(20,:)))*100;

end

