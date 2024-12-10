{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-openid-connect";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-openid-connect";
    rev = "07e30e59bf5ca3925328e936359a5564d7f5b0af";
    sha256 = "sha256-uqxwUjbkS2o9r9pvnTgv+3jzFhUOb8KmorT3ody2d3o=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-openid-connect";
    maintainers = with maintainers; [ mkg20001 ];
    license = licenses.mit;
    description = "Discourse plugin to integrate Discourse with an openid-connect login provider.";
  };
}
