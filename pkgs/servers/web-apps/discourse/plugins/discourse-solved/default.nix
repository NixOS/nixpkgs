{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-solved";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-solved";
    rev = "179611766d53974308e6f7def21836997c3c55fc";
    sha256 = "sha256:1s77h42d3bv2lqw33akxh8ss482vxnz4d7qz6xicwqfwv34qjf03";
  };
}
