{
  abnc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yj09gc9w208wsy0d45vzha4zfwxdpsqvkm9vms0chm4lxdwdg9x";
      type = "gem";
    };
    version = "0.1.1";
  };
  abnftt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z7ibh0xv9mqk61rvvmz9fnfk6hffvnppqd8fx61vazjhisi9bcs";
      type = "gem";
    };
    version = "0.2.4";
  };
  base32 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjs0l3c5g9qxwp43kcnhc45slx29yjb6m6jxbb2x1krgjmi166b";
      type = "gem";
    };
    version = "0.3.4";
  };
  cbor-canonical = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fhj51s5d9b9spw096sb0p92bgilw9hrsay383563dh913j2jn11";
      type = "gem";
    };
    version = "0.1.2";
  };
  cbor-deterministic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w1mg4mn1dhlxlbijxpzja8m8ggrjs0hzkzvnaazw9zm1ji6dpba";
      type = "gem";
    };
    version = "0.1.3";
  };
  cbor-diag = {
    dependencies = ["cbor-canonical" "cbor-deterministic" "cbor-packed" "json_pure" "neatjson" "treetop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwd88xngbjamgydj9rg3wvgl53pfzhal2n702s9afa1yp8mjm51";
      type = "gem";
    };
    version = "0.8.7";
  };
  cbor-packed = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dijyj7rivi39h34f32fx7k4xvngldf569i0372n1z6w01nv761l";
      type = "gem";
    };
    version = "0.1.5";
  };
  cddl = {
    dependencies = ["abnc" "abnftt" "base32" "cbor-diag" "colorize" "json_pure" "regexp-examples"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qll1qvn3g75r742kr4da7240zdk2qj4vh325965rrjqp8brz23q";
      type = "gem";
    };
    version = "0.10.3";
  };
  colorize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dy8ryhcdzgmbvj7jpa1qq3bhhk1m7a2pz6ip0m6dxh30rzj7d9h";
      type = "gem";
    };
    version = "1.1.0";
  };
  json_pure = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09w7f7xlcas9irlaavhz0rnh17cjvjmmqm07drgghx5gwjcrar31";
      type = "gem";
    };
    version = "2.7.1";
  };
  neatjson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wm1lq8yl6rzysh3wg6fa55w5534k6ppiz0qb7jyvdy582mk5i0s";
      type = "gem";
    };
    version = "0.10.5";
  };
  polyglot = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  regexp-examples = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wfkwczjn62qq3z96dxk43m0gh6d5cajx9pxkanvk88d3yqnx29v";
      type = "gem";
    };
    version = "1.5.1";
  };
  treetop = {
    dependencies = ["polyglot"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0adc8qblz8ii668r3rksjx83p675iryh52rvdvysimx2hkbasj7d";
      type = "gem";
    };
    version = "1.6.12";
  };
}
