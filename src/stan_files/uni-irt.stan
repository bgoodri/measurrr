# include /chunks/license.stan

data {
	int<lower=1> J;								// number of respondents
	int<lower=1> K;								// number of items
	int<lower=1> N;								// number of observations
	int<lower=1,upper=J> jj[N];					// student for observation n
	int<lower=1,upper=K> kk[N];					// item for observation n
	int<lower=0,upper=1> y[N];					// correctness for observation n
}
parameters {
	real theta[J];								// ability of j
	real b[K];									// difficulty of k
	real<lower=0> a[K];							// discrimination of k
	real<lower=0,upper=1> c[K];					// lower asymptote of k
}
model {
	vector[N] eta;
	theta ~ normal(0, 1);
	b ~ normal(0, 10);
	a ~ lognormal(0.5, 1);
	c ~ beta(5, 17);

	for(n in 1:N)
		eta[n] = c[kk[n]] + (1 - c[kk[n]]) * inv_logit(a[kk[n]] * (theta[jj[n]] - b[kk[n]]));

	y ~ bernoulli(eta);
}
