{
  daemons = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bmb4qrd95b5gl3ym5j3q6mf090209f4vkczggn49n56w6s6zldz";
      type = "gem";
    };
    version = "1.2.4";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17jr1caa3ggg696dd02g2zqzdjqj9x9q2nl7va82l36f7c5v6k4z";
      type = "gem";
    };
    version = "1.0.9.1";
  };
  mail = {
    dependencies = ["mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d7lhj2dw52ycls6xigkfz6zvfhc6qggply9iycjmcyj9760yvz9";
      type = "gem";
    };
    version = "2.6.6";
  };
  mailcatcher = {
    dependencies = ["eventmachine" "mail" "rack" "sinatra" "skinny" "sqlite3" "thin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6gk8n18i5f651f244al1hscjzl27fpma4vqw0qhszqqpd5p3bx";
      type = "gem";
    };
    version = "0.6.5";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  skinny = {
    dependencies = ["eventmachine" "thin"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y3yvx88ylgz4d2s1wskjk5rkmrcr15q3ibzp1q88qwzr5y493a9";
      type = "gem";
    };
    version = "0.2.4";
  };
  sqlite3 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hrq9m3hb6pm8yrqshhg0gafkphdpvwcqmr7k722kgdisp3w91ga";
      type = "gem";
    };
    version = "1.5.1";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1is1ayw5049z8pd7slsk870bddyy5g2imp4z78lnvl8qsl8l0s7b";
      type = "gem";
    };
    version = "2.0.7";
  };
}