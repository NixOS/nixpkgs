{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-github";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-github";
    rev = "151e353a5a1971157c70c2e2b0f56387f212a81f";
    sha256 = "00kra6zd2k1f2vwcdvxnxnammzh72f5qxcqbb94m0z6maj598wdy";
  };
}
