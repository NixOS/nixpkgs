{
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01hj8v1qnyl5ndrs33g8ld8ibk0rbcqdpkpznr04gkbxd11pqn67";
      type = "gem";
    };
    version = "1.12.1";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1af7aa1c2npi8dkshgm3f8qyacabm94ckrdz7b8vd3f8zzswqzp9";
      type = "gem";
    };
    version = "2.5.1.0";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1idi53jay34ba9j68c3mfr9wwkg3cd9qh0fn9cg42hv72c6q8dyg";
      type = "gem";
    };
    version = "12.3.1";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17qnk66q4diny1bvzbwsl1d5a26nj0mjzc2425h6nyp3xqjipz11";
      type = "gem";
    };
    version = "0.55.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1igh1xivf5h5g3y5m9b4i4j2mhz2r43kngh4ww3q1r80ch21nbfk";
      type = "gem";
    };
    version = "1.9.0";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x31fgv1acywbb50prp7y4fr677c2d9gsl6wxmfcrlxbwz7nxn5n";
      type = "gem";
    };
    version = "1.3.2";
  };
}