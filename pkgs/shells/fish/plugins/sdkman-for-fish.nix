{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "sdkman-for-fish";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "reitzig";
    repo = "sdkman-for-fish";
    rev = "v${version}";
    hash = "sha256-7cgyR3hQ30Jv+9lJS5qaBvSaI/0YVT8xPXlUhDBTdFc=";
  };

<<<<<<< HEAD
  meta = {
    description = "Adds support for SDKMAN! to fish";
    homepage = "https://github.com/reitzig/sdkman-for-fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giorgiga ];
=======
  meta = with lib; {
    description = "Adds support for SDKMAN! to fish";
    homepage = "https://github.com/reitzig/sdkman-for-fish";
    license = licenses.mit;
    maintainers = with maintainers; [ giorgiga ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
