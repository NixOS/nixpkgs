{
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
      type = "gem";
    };
    version = "2.3.0";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nply96nqrkgx8d3jay31sfy5p4q74dg8ymln0mdazxx5cz2n8bq";
      type = "gem";
    };
    version = "2.3.3.1";
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
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0frz90gyi5k26jx3ham1x661hpkxf82rkxb85nakcz70dna7i8ri";
      type = "gem";
    };
    version = "2.2.1";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01j8fc9bqjnrsxbppncai05h43315vmz9fwg28qdsgcjw9ck1d7n";
      type = "gem";
    };
    version = "12.0.0";
  };
  rubocop = {
    dependencies = ["parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lsv3zbjl14nqyqqvcwciz15nq76l7vg97nydrdsrxs2bc5jrlsm";
      type = "gem";
    };
    version = "0.47.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qzc7s7r21bd7ah06kskajc2bjzkr9y0v5q48y0xwh2l55axgplm";
      type = "gem";
    };
    version = "1.8.1";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r28mxyi0zwby24wyn1szj5hcnv67066wkv14wyzsc94bf04fqhx";
      type = "gem";
    };
    version = "1.1.3";
  };
}
