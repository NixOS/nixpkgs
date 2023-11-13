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
    dependencies = ["builder" "cucumber-ci-environment" "cucumber-core" "cucumber-cucumber-expressions" "cucumber-gherkin" "cucumber-html-formatter" "cucumber-messages" "diff-lcs" "mime-types" "multi_test" "sys-uname"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ahpifcqv0h5r9cgd97fwr73ps90h50jzi0h17zsaw4ksb3b6g2m";
      type = "gem";
    };
    version = "8.0.0";
  };
  cucumber-ci-environment = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nmn2hfrjlbazgcryr3hwvsa5v4csfbjqxb4q7wbjhaxl9xxn0k7";
      type = "gem";
    };
    version = "9.1.0";
  };
  cucumber-core = {
    dependencies = ["cucumber-gherkin" "cucumber-messages" "cucumber-tag-expressions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0drg9w5cz5mchh077y9ixsy7yiyrzg3cqc29mmkl3vjcwlkhn3rh";
      type = "gem";
    };
    version = "11.0.0";
  };
  cucumber-cucumber-expressions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xkgpy69p24winh4p5q2b3534i02xxbxl5rn0capqv97qjyj63j";
      type = "gem";
    };
    version = "15.2.0";
  };
  cucumber-gherkin = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dsvcjy78c114q3znacs25zhq3f49q9kkxq4j9iw8b6kwimrl8wj";
      type = "gem";
    };
    version = "23.0.1";
  };
  cucumber-html-formatter = {
    dependencies = ["cucumber-messages"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gnmm1r4gyqqwzx482zsbahjyamnj0lxxky86zs4a376jv9bicyz";
      type = "gem";
    };
    version = "19.2.0";
  };
  cucumber-messages = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i8abkxykq7ab15pirrrf0jz9200i3x3pda2ffyxmck6063lyjgv";
      type = "gem";
    };
    version = "18.0.0";
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
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "003gd7mcay800k2q4pb2zn8lwwgci4bhi42v2jvlidm8ksx03i6q";
      type = "gem";
    };
    version = "3.2022.0105";
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
      sha256 = "0gk625krfm00nppb2ni0794kzr1cqbs1a0059fhp4s3lcrmx69jc";
      type = "gem";
    };
    version = "1.2.2";
  };
}
