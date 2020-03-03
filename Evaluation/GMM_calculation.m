% Calculation for the Log-likelihood distances between the real EEG and GMM samples (Real~ GMM) Vs 
% the generated samples and GMM samples (Gen~GMM) 

% Selecting a channel(ch) for GMM evaluation out of 64

ch = 1;
X= squeeze(target_real(:,ch,:));

%determining the no of GMMs using BCI method 

options = statset('Display','final');
GMModel = fitgmdist(X,2,'CovarianceType','diagonal','Options',options);

% Examine the BIC over varying numbers of components k, here we check for maximum 10 GMM component.

BIC = zeros(1,10);
GMModels = cell(1,10);
options = statset('MaxIter',500);
for k = 1:10
    GMModels{k} = fitgmdist(X,k,'Options',options,'CovarianceType','diagonal','RegularizationValue',0.1);
    BIC(k)= GMModels{k}.BIC;
end

[minBIC,numComponents] = min(BIC);
numComponents % out put the number of GMM component fitted, let's say 4 GMM components are fitted 

% GMM likelihood for 4 components, same can be calculated for other GMM components
gm = fitgmdist(X,numComponents,'RegularizationValue',0.1);

X1=X; % likelihood distance from real samples
% X1 = squeeze(target_gen(:,ch,:)); uncomment for likelihhod distance from generated samples 

mu = gm.mu;
mu1=mu(1,:);mu2=mu(2,:);mu3=mu(3,:);mu4=mu(4,:);

sigma=gm.Sigma;
sigma1= sigma(:,:,1);sigma2= sigma(:,:,2);sigma3= sigma(:,:,3);sigma4= sigma(:,:,4);
% likelihood from GMM components
d1 = mvnpdf(X1,mu1,sigma1);d2 = mvnpdf(X1,mu2,sigma2);d3 = mvnpdf(X1,mu3,sigma3);d4 = mvnpdf(X1,mu4,sigma4);
d = [d1,d2,d3,d4];   
p = gm.ComponentProportion;
% weighing wih the component proportion 
distance = d*p';
Average_distance_real = log(mean(distance, 1))

% Similarly the proposed distance measure can be calculated for all other channels, and nontarget data.  
