{
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  cucumber = {
    dependencies = ["builder" "cucumber-ci-environment" "cucumber-core" "cucumber-cucumber-expressions" "cucumber-gherkin" "cucumber-html-formatter" "cucumber-messages" "diff-lcs" "mini_mime" "multi_test" "sys-uname"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gmbbj4s4cv9aifks29q9w9yjcrvihcz1i8sijplwbps7334skv1";
      type = "gem";
    };
    version = "9.1.0";
  };
  cucumber-ci-environment = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a11b6w6khjb7rw7ksxdw4bprmg9gfc8xdrsbgv8767ri891s4lq";
      type = "gem";
    };
    version = "9.2.0";
  };
  cucumber-core = {
    dependencies = ["cucumber-gherkin" "cucumber-messages" "cucumber-tag-expressions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylxpganbvlzcd4picmgbs060cf0nlpkjc7lqxndyr6xaz2g99y2";
      type = "gem";
    };
    version = "12.0.0";
  };
  cucumber-cucumber-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xyvg7l2y9b9gh682z47zcf1na179n8j7bwfyahp79w8s047660b";
      type = "gem";
    };
    version = "17.0.1";
  };
  cucumber-gherkin = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0in9cn9pza3vylc1mlpc3ivri493ikq7f9pnsjkfr6ahagacnh4i";
      type = "gem";
    };
    version = "26.2.0";
  };
  cucumber-html-formatter = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1al5cafzbiqd7fhwyvs0xcpjszav0q5816x9r02v3hzri10wvp5s";
      type = "gem";
    };
    version = "20.4.0";
  };
  cucumber-messages = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06d7dnixz68ivngf6qflmi6xrjshjyi85gmyjrl07pbmhqi6r2nh";
      type = "gem";
    };
    version = "22.0.0";
  };
  cucumber-tag-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rmbw044fdy2756ypnqray8abfxqvwrn1jhsdafdbjwihvvsk62f";
      type = "gem";
    };
    version = "5.0.6";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yvii03hcgqj30maavddqamqy50h7y6xcn2wcyq72wn823zl4ckd";
      type = "gem";
    };
    version = "1.16.3";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_test = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "042d6a1416h3di57z107ygmjdgacrpyswi73ryz75yv3v36m1rg9";
      type = "gem";
    };
    version = "1.1.0";
  };
  sys-uname = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03j9qpqip89a0vk6s0gvhxzhbvafjcj5rss7i3jwha0831aivib3";
      type = "gem";
    };
    version = "1.2.3";
  };
}
