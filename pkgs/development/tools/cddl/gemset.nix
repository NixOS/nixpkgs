{
  abnc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13nvzrk72nj130fs8bq8q3cfm48939rdzh7l31ncj5c4969hrbig";
      type = "gem";
    };
    version = "0.1.0";
  };
  cbor-diag = {
    dependencies = ["json" "neatjson" "treetop"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pd0k4malg1l7w3ck5glh9w0hrsvknk8rp32vrir74yww1g6yplv";
      type = "gem";
    };
    version = "0.5.6";
  };
  cddl = {
    dependencies = ["abnc" "cbor-diag" "colorize" "json" "regexp-examples"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gvh7n1vckrgz9wdfbfpk10h7vhg9kplfpacaybbmnbk1wjn961k";
      type = "gem";
    };
    version = "0.8.10";
  };
  colorize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
  };
  neatjson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fa2v7b6433j0iqh5iq9r71v7a5xabgjvqwsbl21vcsac7vf3ncw";
      type = "gem";
    };
    version = "0.9";
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
      sha256 = "0g31pijhnv7z960sd09lckmw9h8rs3wmc8g4ihmppszxqm99zpv7";
      type = "gem";
    };
    version = "1.6.10";
  };
}
