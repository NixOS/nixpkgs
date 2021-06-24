{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-yearly-review";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-yearly-review";
    rev = "d1471bdb68945f55342e72e2c525b4f628419a50";
    sha256 = "sha256:0xpl0l1vpih8xzb6y7k1lm72nj4ya99378viyhqfvpwzsn5pha2a";
  };
}
