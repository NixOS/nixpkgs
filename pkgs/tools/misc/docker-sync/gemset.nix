{
  backticks = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vr28l9vckavnrb9pnqrhcmnk3wsvvpas8jjh165w2rzv3sdkws5";
      type = "gem";
    };
    version = "1.0.2";
  };
  daemons = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l5gai3vd4g7aqff0k1mp41j9zcsvm2rbwmqn115a325k9r7pf4w";
      type = "gem";
    };
    version = "1.3.1";
  };
  docker-compose = {
    dependencies = ["backticks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00v3y182rmpq34dl91iprvhc50vw8hysy2h7iy3ihmmm9pgg71gc";
      type = "gem";
    };
    version = "1.1.10";
  };
  docker-sync = {
    dependencies = ["daemons" "docker-compose" "dotenv" "gem_update_checker" "os" "terminal-notifier" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrlcggj7k8w30b76f23p64yx4wg7p7mq9lp6lsnh2ysq9n3cjqg";
      type = "gem";
    };
    version = "0.5.9";
  };
  dotenv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rgl2kqhnxqbjvi9brbvb52iaq1z8yi0pl0bawk4fm6kl9igxr8f";
      type = "gem";
    };
    version = "2.6.0";
  };
  gem_update_checker = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ckbz4q3q59kkv138n0cmsyida0wg45pwscxzf5vshxcrxhmq3x7";
      type = "gem";
    };
    version = "0.2.0";
  };
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s401gvhqgs2r8hh43ia205mxsy1wc0ib4k76wzkdpspfcnfr1rk";
      type = "gem";
    };
    version = "1.0.0";
  };
  terminal-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slc0y8pjpw30hy21v8ypafi8r7z9jlj4bjbgz03b65b28i2n3bs";
      type = "gem";
    };
    version = "2.0.0";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
}
