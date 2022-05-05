{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-canned-replies";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-canned-replies";
    rev = "18af3367d9eda8842e8ff0de96c90aa2f0bdb0a3";
    sha256 = "sha256-v8QOR0/9RUJ1zFmzhKYe/GEev3Jl4AlXWkQyuquyuJY=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-canned-replies";
    maintainers = with maintainers; [ talyz ];
    license = licenses.gpl2Only;
    description = "Adds support for inserting a canned reply into the composer window via a UI";
  };
}
