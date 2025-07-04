{
  anystyle = {
    dependencies = [
      "anystyle-data"
      "bibtex-ruby"
      "namae"
      "wapiti"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "c6f5fb2fa6e8ce9456ad1e1e88d6bba5f3d7731d";
      hash = "sha256-gvJes3yn4M0QMcNmIQfznfDwzXaxZS43ww0Ir7SMULs=";
      type = "git";
      url = "https://github.com/inukshuk/anystyle.git";
    };
    version = "1.6.0";
  };
  anystyle-cli = {
    dependencies = [
      "anystyle"
      "gli"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "1.5.0";
  };
  anystyle-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xJtieuEAe6E5K9r1yqBKznV+9UjCbsDJymw1x16vSFA=";
      type = "gem";
    };
    version = "1.3.0";
  };
  bibtex-ruby = {
    dependencies = [
      "latex-decode"
      "racc"
    ];
    groups = [ "extra" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JjHHQr4YWxpt9rQxIG94zmc75lKBFnKNCs6Q+IIU/b0=";
      type = "gem";
    };
    version = "6.1.0";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  date = {
    groups = [
      "debug"
      "default"
      "extra"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  debug = {
    dependencies = [
      "irb"
      "reline"
    ];
    groups = [ "debug" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EeKMp0h1l55hJEQQTzlyvV/7nnkXmQfXrUbbpEvS56Q=";
      type = "gem";
    };
    version = "1.10.0";
  };
  erb = {
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dgQ5gDs2zJPsqKJmqrYUYU5YgCSom8MKYueNmP9FLCM=";
      type = "gem";
    };
    version = "5.0.1";
  };
  gli = {
    dependencies = [ "ostruct" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WA6NbIiw8PDLjossoYw0he0PdCzs6FXeRr+ONiAvXbA=";
      type = "gem";
    };
    version = "2.22.2";
  };
  io-console = {
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ii8ylS4njaNLWP/kXoY0v0r8LceqnaI/7WflgapQ/bo=";
      type = "gem";
    };
    version = "1.15.2";
  };
  latex-decode = {
    groups = [
      "default"
      "extra"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4mBr0FhPxTk/Kkue+Qf/SFc7i61AE72pyfjCx/+wvfg=";
      type = "gem";
    };
    version = "0.4.0";
  };
  namae = {
    dependencies = [ "racc" ];
    groups = [
      "default"
      "extra"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NUHOSwhv1JgdI3ZjDAPihEAr/hzbq05Q4iIqcq651Z0=";
      type = "gem";
    };
    version = "1.2.0";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prettyprint = {
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gUMoql3LbWBNMhJqILwcvPBVIaW0nbsaizCgflgPMW4=";
      type = "gem";
    };
    version = "5.2.6";
  };
  racc = {
    groups = [
      "default"
      "extra"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rdoc = {
    dependencies = [
      "erb"
      "psych"
    ];
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LEbeWNcSm4dD/PbXbj25cb3JFBUOFawGs4ZUm9gu19s=";
      type = "gem";
    };
    version = "6.14.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "debug"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GvzJ18sQKc2+eA1y8vCSUc5G03gAUPPsOcPMxrYGdfs=";
      type = "gem";
    };
    version = "0.6.1";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  stringio = {
    groups = [
      "debug"
      "default"
      "extra"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3i3yyQqMV+0/KYaglXWLsQ49Y2iuQvmYEhUat5FB/o=";
      type = "gem";
    };
    version = "3.1.7";
  };
  wapiti = {
    dependencies = [
      "builder"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TUGbjmTv+Cq6AQ/ggsNoEbN/0XNUnThIj3PdApY9cKU=";
      type = "gem";
    };
    version = "2.1.0";
  };
}
