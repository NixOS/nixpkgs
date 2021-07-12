{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-canned-replies";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-canned-replies";
    rev = "7ee748f18a276aca42185e2079c1d4cadeecdaf8";
    sha256 = "0j10kxfr6v2rdd58smg2i7iac46z74qnnjk8b91jd1svazhis1ph";
  };
}
