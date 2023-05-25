{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-canned-replies";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-canned-replies";
    rev = "5a2d9a11ef3f07fc781acd83770bafc14eca2c1b";
    sha256 = "sha256-R6CmL1hqqybc/I3oAzr3xZ4WThPWQirMjlXkF82xmIk=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-canned-replies";
    maintainers = with maintainers; [ talyz ];
    license = licenses.gpl2Only;
    description = "Adds support for inserting a canned reply into the composer window via a UI";
  };
}
