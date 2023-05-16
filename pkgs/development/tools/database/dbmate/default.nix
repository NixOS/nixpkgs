<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.5.0";
=======
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dbmate";
  version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-s3J5Mf+eCChIGmm89nq1heoJKscCA9nINGAGe0/qxaI=";
  };

  vendorHash = "sha256-ohSwDFisNXnq+mqGD2v4X58lumHvpyTyJxME418GSMY=";
=======
    rev = "v${version}";
    sha256 = "sha256-K81AyhQfM1hBoA1gpU1MdcdkUnn2YKyig+fExVsMwMI=";
  };

  vendorHash = "sha256-NZ2HVFViU8Vzwyo33cueNJwdCT4exZlB7g4WgoWKZBE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    homepage = "https://github.com/amacneil/dbmate";
<<<<<<< HEAD
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
=======
    license = licenses.mit;
    maintainers = [ maintainers.manveru ];
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
