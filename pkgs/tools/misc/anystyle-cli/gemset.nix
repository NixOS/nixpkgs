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
      sha256 = "1fshijsay20dqcvjwrdifv6z1w4xyc3j2rn3648cvq57gjrmxwl2";
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
      sha256 = "0l28mxgcfdbcrb4w0vn293spwxff9ahcmxfs5cws2yq0w5x656y4";
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
      sha256 = "1ggx2j1gi46f1a6p45l1abk3nryfg1pj0cdlyrnilnqqpr1cfc96";
      type = "gem";
    };
    version = "6.1.0";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
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
      sha256 = "0kz6mc4b9m49iaans6cbx031j9y7ldghpi5fzsdh0n3ixwa8w9mz";
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
      sha256 = "1977s95s9ns6mpbhg68pg6ggnpxxf8wly4244ihrx5vm92kqrqhi";
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
      sha256 = "08rc8pzri3g7c85c76x84j05hkk12jvalrm2m3n97k1n7f03j13n";
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
      sha256 = "1c2x5wh3d3mz8vg5bs7c5is0zvc56j6a2b4biv5z1w5hi1n8s3jq";
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
      sha256 = "18pgvl7lfjpichdfh1g50rpz0zpaqrpr52ybn9liv1v9pjn9ysnd";
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
      sha256 = "1fpxa2m83rb7xlzs57daqwnzqjmz6j35xr7zb15s73975sak4br2";
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
      sha256 = "1y5xn3zwghpqr6lvs4s0mn5knms8zw3zk7jb58zkkiagb386nq72";
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
      sha256 = "17fmp6p74ai2w984xayv3kz2nh44w81hqqvn4cfrim3g115wwh9m";
      type = "gem";
    };
    version = "1.2.0";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05xqijcf80sza5pnlp1c8whdaay8x5dc13214ngh790zrizgp8q9";
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
      sha256 = "1zxnfxjni0r9l2x42fyq0sqpnaf5nakjbap8irgik4kg1h9c6zll";
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
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
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
      sha256 = "0vii1xc7x81hicdbp7dlllhmbw5w3jy20shj696n0vfbbnm2hhw1";
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
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
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
      sha256 = "1nyp5vc9nm46nc3aq58f2lackgbip4ynxmznzi1qg6qjsxcdwiic";
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
      sha256 = "1yvm0svcdk6377ng6l00g39ldkjijbqg4whdg2zcsa8hrgbwkz0s";
      type = "gem";
    };
    version = "0.6.1";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jmbf6lf7pcyacpb939xjjpn1f84c3nw83dy3p1lwjx0l2ljfif7";
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
      sha256 = "1yh78pg6lm28c3k0pfd2ipskii1fsraq46m6zjs5yc9a4k5vfy2v";
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
      sha256 = "19bh7nb05pbkix43i7alfg8pzcqid31q5q0g06x2my7gcj79nhad";
      type = "gem";
    };
    version = "2.1.0";
  };
}
