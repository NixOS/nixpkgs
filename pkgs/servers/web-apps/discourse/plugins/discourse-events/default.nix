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
    rev = "5e22962b7346dbcdb579e7c3abb13c5c965c3c42";
    sha256 = "sha256-IZ7xJaPb44CZOtg4xA4crCe4//oZO3pjkgvXOM1lihE=";
  };
  meta = {
    homepage = "https://github.com/angusmcleod/discourse-events";
    maintainers = [ lib.maintainers.leona ];
    license = lib.licenses.gpl2Plus;
    description = "Discourse plugin to manage events";
  };
}
