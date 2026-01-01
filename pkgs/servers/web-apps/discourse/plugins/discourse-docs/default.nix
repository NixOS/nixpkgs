{
  lib,
  mkDiscoursePlugin,
  fetchFromGitHub,
}:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "ff5d738a9f9d85847e6fc226f8324ad9cf466007";
    sha256 = "sha256-p5QYM6jbsqe9a3UouHdVimSxZeBvsoM/hb0UQ7iV1IM=";
  };
<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with lib.maintainers; [ dpausp ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Find and filter knowledge base topics";
  };
}
