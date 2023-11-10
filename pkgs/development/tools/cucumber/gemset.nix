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
      sha256 = "0hwbq5sn4hsd922j1p3a4p2404306yczgx2vqggvr20q01fzx55h";
      type = "gem";
    };
    version = "9.0.2";
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
      sha256 = "02mrykswrxziy08fc9fjvg3l2aa6jfji2012wzh7pyamhm8pcnjb";
      type = "gem";
    };
    version = "11.1.0";
  };
  cucumber-cucumber-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8bazf8bwlm0zar2316p4xxmpy44wyjnw2z6bj7zc5nl8nmyvym";
      type = "gem";
    };
    version = "16.1.2";
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
      sha256 = "0482a63y7my0arn2bv208g401dq8525f0gwhnwaa11mhv6ph0q5i";
      type = "gem";
    };
    version = "21.0.1";
  };
  cucumber-tag-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v1ssg4chkahck1ddl2j1hcifm0vlcn9sb104ywshw5gyv59s9qd";
      type = "gem";
    };
    version = "4.1.0";
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
