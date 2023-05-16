<<<<<<< HEAD
{ lib, rustPlatform, fetchCrate }:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bnjrbcQ2MMZsM0rWWk+xkA58rSREHWfSvlGDAHKIPAw=";
  };

  cargoHash = "sha256-8NgEsFglt+JyP5D61mT4Z8SIbPATJskiEpn8tWy+yjk=";
=======
{ lib
, stdenv
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-STeLEHgggshhyLCfqiJmDcmwxqQ1AOGHj2ATliEY+DA=";
  };

  cargoHash = "sha256-GGi4OduO9FPIWllxlx4tK3lix36zF0FNDyptzftV0GY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description =
      "A silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
  };
}
