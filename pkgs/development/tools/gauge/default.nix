{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
<<<<<<< HEAD
  version = "1.5.2";
=======
  version = "1.4.3";

  excludedPackages = [ "build" "man" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gdqb9atksAU2bjNdoOfxb3XYl3H/1F51Xnfnm78J3CQ=";
  };

  vendorHash = "sha256-PmidtbtX+x5cxuop+OCrfdPP5EiJnyvFyxHveGVGAEo=";

  excludedPackages = [ "build" "man" ];
=======
    sha256 = "sha256-TszZAREk6Hs2jULjftQAhHRIVKaZ8fw0NLJkBdr0FPw=";
  };

  vendorSha256 = "1wp19m5n85c7lsv8rvcbfz1bv4zhhb7dj1frkdh14cqx70s33q8r";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
