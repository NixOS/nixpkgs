{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
}:

buildFishPlugin rec {
  pname = "done";
<<<<<<< HEAD
  version = "1.21.1";
=======
  version = "1.20.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-GZ1ZpcaEfbcex6XvxOFJDJqoD9C5out0W4bkkn768r0=";
=======
    hash = "sha256-WA6DBrPBuXRIloO05UBunTJ9N01d6tO1K1uqojjO0mo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

<<<<<<< HEAD
  meta = {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.malo ];
=======
  meta = with lib; {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
