{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_featureserv";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Kii9Qbff6dIAaHx3QfNPTg8g+QrBpZghGlHxrsGaMbo=";
  };

  vendorHash = "sha256-BHiEVyi3FXPovYy3iDP8q+y+LgfI4ElDPVZexd7nnuo=";
=======
    sha256 = "0lfsbsgcb7z8ljxn1by37rbx02vaprrpacybk1kja1rjli7ik7m9";
  };

  vendorSha256 = null; #vendorSha256 = "";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X github.com/CrunchyData/pg_featureserv/conf.setVersion=${version}" ];

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = with maintainers; [ sikmir ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
