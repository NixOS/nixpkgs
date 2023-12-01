{ lib, rustPlatform, fetchCrate }:
rustPlatform.buildRustPackage rec {
  pname = "cfonts";
  version = "1.1.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-bnjrbcQ2MMZsM0rWWk+xkA58rSREHWfSvlGDAHKIPAw=";
  };

  cargoHash = "sha256-8NgEsFglt+JyP5D61mT4Z8SIbPATJskiEpn8tWy+yjk=";

  meta = with lib; {
    homepage = "https://github.com/dominikwilkowski/cfonts";
    description =
      "A silly little command line tool for sexy ANSI fonts in the console";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ leifhelm ];
    mainProgram = "cfonts";
  };
}
