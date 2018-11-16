{
  abnc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13nvzrk72nj130fs8bq8q3cfm48939rdzh7l31ncj5c4969hrbig";
      type = "gem";
    };
    version = "0.1.0";
  };
  cbor-diag = {
    dependencies = ["json" "treetop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4pxf1ag4pyb351m06l08ig1smnf8w27ynqfxkgmwak5mh1z7w1";
      type = "gem";
    };
    version = "0.5.2";
  };
  cddl = {
    dependencies = ["abnc" "cbor-diag" "colorize" "json" "regexp-examples"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pg91wrby0qgrdnf089ddy5yy2jalxd3bb9dljj16cpwv4gjx047";
      type = "gem";
    };
    version = "0.8.5";
  };
  colorize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  polyglot = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqnxwyip623d8pr29rg6m8r0hdg08fpr2yb74f46rn1wgsnxmjr";
      type = "gem";
    };
    version = "0.3.5";
  };
  regexp-examples = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "104f0j0h2x5ijly7kyaj7zz0md65r2c03cpbi5cngm0hs2sr1qkz";
      type = "gem";
    };
    version = "1.4.2";
  };
  treetop = {
    dependencies = ["polyglot"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g31pijhnv7z960sd09lckmw9h8rs3wmc8g4ihmppszxqm99zpv7";
      type = "gem";
    };
    version = "1.6.10";
  };
}