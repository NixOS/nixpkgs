{
  backports = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17j5pf0b69bkn043wi4xd530ky53jbbnljr4bsjzlm4k8bzlknfn";
      type = "gem";
    };
    version = "3.14.0";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-core" "cucumber-expressions" "cucumber-wire" "diff-lcs" "gherkin" "multi_json" "multi_test"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2brssrpal8hyhcgg974x3xyhpmvpwps5ypd9p8w2lg01l1pp3j";
      type = "gem";
    };
    version = "3.1.2";
  };
  cucumber-core = {
    dependencies = ["backports" "cucumber-tag_expressions" "gherkin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iavlh8hqj9lwljbpkw06259gdicbr1bdb6pbj5yy3n8szgr8k3c";
      type = "gem";
    };
    version = "3.2.1";
  };
  cucumber-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zwmv6hznyz9vk81f5dhwcr9jhxx2vmbk8yyazayvllvhy0fkpdw";
      type = "gem";
    };
    version = "6.0.1";
  };
  cucumber-tag_expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvmbljybws0qzjs1l67fvr9gqr005l8jk1ni5gcsis9pfmqh3vc";
      type = "gem";
    };
    version = "1.1.1";
  };
  cucumber-wire = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ymvqb0sbw2if1nxg8rcj33sf0va88ancq5nmp8g01dfwzwma2f";
      type = "gem";
    };
    version = "0.0.1";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  gherkin = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cgcdchwwdm10rsk44frjwqd4ihprhxjbm799nscqy2q1raqfj5s";
      type = "gem";
    };
    version = "5.1.0";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multi_test = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sx356q81plr67hg16jfwz9hcqvnk03bd9n75pmdw8pfxjfy1yxd";
      type = "gem";
    };
    version = "0.1.2";
  };
}