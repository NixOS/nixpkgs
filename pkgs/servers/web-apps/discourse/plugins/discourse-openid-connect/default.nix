{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-openid-connect";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-openid-connect";
    rev = "43a30dde4a64a01250f4447e74806db65ee7ae1a";
    sha256 = "sha256-/3AE5cDELKfKwEY+XqaZ6SzJp6XAnW83r67kzLGaV2M=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-openid-connect";
    maintainers = with maintainers; [ mkg20001 ];
    license = licenses.mit;
    description = "Discourse plugin to integrate Discourse with an openid-connect login provider.";
  };
}

