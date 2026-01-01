{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "fishtape";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "fishtape";
    rev = version;
    sha256 = "072a3qbk1lpxw53bxp91drsffylx8fbywhss3x0jbnayn9m8i7aa";
  };

  checkFunctionDirs = [ "./functions" ]; # fishtape is introspective
  checkPhase = ''
    fishtape tests/*.fish
  '';

<<<<<<< HEAD
  meta = {
    description = "100% pure-Fish test runner";
    homepage = "https://github.com/jorgebucaran/fishtape";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ euxane ];
=======
  meta = with lib; {
    description = "100% pure-Fish test runner";
    homepage = "https://github.com/jorgebucaran/fishtape";
    license = licenses.mit;
    maintainers = with maintainers; [ euxane ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
