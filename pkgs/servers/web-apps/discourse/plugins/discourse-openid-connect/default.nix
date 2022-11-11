{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-openid-connect";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-openid-connect";
    rev = "0817bef63a17771da217c3f8b4db740157a06a3b";
    sha256 = "sha256-uN03WhyY2v6OwOpy1aHPmBH6tMgmVcwQyVJZTVhaysA=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-openid-connect";
    maintainers = with maintainers; [ mkg20001 ];
    license = licenses.mit;
    description = "Discourse plugin to integrate Discourse with an openid-connect login provider.";
  };
}

