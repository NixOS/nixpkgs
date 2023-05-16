{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "shiori";
<<<<<<< HEAD
  version = "1.5.5";

  vendorHash = "sha256-suWdtqf5IZntEVD+NHGD6RsL1tjcGH9vh5skISW+aCc=";
=======
  version = "1.5.4";

  vendorHash = "sha256-8aiaG2ry/XXsosbrLBmwnjbwIhbKMdM6WHae07MG7WI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  src = fetchFromGitHub {
    owner = "go-shiori";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-kGPvCYvLLixEH9qih/F3StUyGPqlKukTWLSw41+Mq8E=";
=======
    sha256 = "sha256-QZTYhRz65VLs3Ytv0k8ptfeQ/36M2VBXFaD9zhQXDh8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.tests = {
    smoke-test = nixosTests.shiori;
  };

  meta = with lib; {
    description = "Simple bookmark manager built with Go";
    homepage = "https://github.com/go-shiori/shiori";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
