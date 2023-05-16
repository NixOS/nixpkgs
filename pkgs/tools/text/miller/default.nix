{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "miller";
<<<<<<< HEAD
  version = "6.9.0";
=======
  version = "6.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "johnkerl";
    repo = "miller";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-g2Jnqo3U9acyqohGpcEEogq871qJQTc7k0/oIawAQW8=";
  };

  vendorHash = "sha256-/1/FTQL3Ki8QzL+1J4Ah8kwiJyGPd024di/1MC8gtkE=";
=======
    sha256 = "sha256-fKgw4ii/riPTklEB+Q8/sOx2dCMS/kevyvXgpyFlkVs=";
  };

  vendorHash = "sha256-uZa9H7Tj2ynwl3fFY9U+WZ0FcNuvHRQf7RCW6rebm5g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/mlr" ];

  meta = with lib; {
    description = "Like awk, sed, cut, join, and sort for data formats such as CSV, TSV, JSON, JSON Lines, and positionally-indexed";
    homepage    = "https://github.com/johnkerl/miller";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ mstarzyk ];
    mainProgram = "mlr";
    platforms   = platforms.all;
  };
}
