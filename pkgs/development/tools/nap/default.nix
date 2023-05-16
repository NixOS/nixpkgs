{ lib, buildGoModule, fetchFromGitHub, callPackage }:

buildGoModule rec {
  pname = "nap";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b3sz8zp1nwcjl02b3lli5yjc7vfay1ig6fs8bgxwz22imfx076p";
  };

<<<<<<< HEAD
  vendorHash = "sha256-puCqql77kvdWTcwp8z6LExBt/HbNRNe0f+wtM0kLoWM=";
=======
  vendorSha256 = "sha256-puCqql77kvdWTcwp8z6LExBt/HbNRNe0f+wtM0kLoWM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  excludedPackages = ".nap";

  meta = {
    description = "Code snippets in your terminal 🛌";
    homepage = "https://github.com/maaslalani/nap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phdcybersec maaslalani ];
  };
}
