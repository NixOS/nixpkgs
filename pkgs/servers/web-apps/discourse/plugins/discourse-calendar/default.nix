{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-calendar";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-calendar";
    rev = "e0efb16264a07f74d1a66f1568cec2774b4b2fa8";
    sha256 = "sha256-IJaa1JOJCOFvnBVK92autgDQCRACYkcJY8T38QQk2Oc=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-calendar";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Adds the ability to create a dynamic calendar in the first post of a topic";
  };
}
