{ lib, buildGoModule, fetchFromGitHub, pkg-config, glib, libxml2 }:

buildGoModule rec {
  pname = "ua";
<<<<<<< HEAD
  version = "unstable-2022-10-23";
=======
  version = "unstable-2021-12-18";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sloonz";
    repo = "ua";
<<<<<<< HEAD
    rev = "f636f5eec425754d8a8be8e767c5b3e4f31fe1f9";
    hash = "sha256-U9fApk/dyz7xSho2W8UT0OGIeOYR/v9lM0LHN2OqTEQ=";
  };

  vendorHash = "sha256-0O80uhxSVsV9N7Z/FgaLwcjZqeb4MqSCE1YW5Zd32ns=";
=======
    rev = "b6d75970bb4f6f340887e1eadad5aa8ce78f30e3";
    sha256 = "sha256-rCp8jyqQfq5eVdvKZz3vKuDfcR+gQOEAfBZx2It/rb0=";
  };

  vendorSha256 = "sha256-0O80uhxSVsV9N7Z/FgaLwcjZqeb4MqSCE1YW5Zd32ns=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libxml2 ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/sloonz/ua";
    license = licenses.isc;
    description = "Universal Aggregator";
    maintainers = with maintainers; [ ttuegel ];
  };
}
