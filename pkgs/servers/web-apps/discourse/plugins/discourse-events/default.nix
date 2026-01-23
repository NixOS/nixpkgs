{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-events";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "angusmcleod";
    repo = "discourse-events";
    rev = "83a6ee2c36a83bdb21fc58e3ec4bbd5fd5953e2e";
    sha256 = "sha256-QNcP32JYaon7phv3sFi1vlWZNwuL+LDzRWe6vi2FwTE=";
  };
  meta = {
    homepage = "https://github.com/angusmcleod/discourse-events";
    maintainers = [ lib.maintainers.leona ];
    license = lib.licenses.gpl2Plus;
    description = "Discourse plugin to manage events";
  };
}
