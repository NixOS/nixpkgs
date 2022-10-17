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
      sha256 = "16rmcrsxwx33pj25g1si0dhjdl2brfhy2vlpfwdb6qqkaikmzhpz";
      type = "gem";
    };
    version = "0.8.9";
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
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
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
      sha256 = "08s5d327i9dw5yjwv9vfss3qb7lwasjyc75wvh7vrdi5v4vm1y2k";
      type = "gem";
    };
    version = "1.5.0";
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
