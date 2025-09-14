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
    rev = "e08efecc012a5ab8fa95084be93d4fd07ccebab9";
    sha256 = "sha256-v4UWFDdOFON+nHkH490kBQ4sXX7Mrp7KVhN1x9HML7w=";
  };
  meta = {
    homepage = "https://github.com/discourse/discourse-openid-connect";
    maintainers = with lib.maintainers; [ mkg20001 ];
    license = lib.licenses.mit;
    description = "Discourse plugin to integrate Discourse with an openid-connect login provider";
  };
}
