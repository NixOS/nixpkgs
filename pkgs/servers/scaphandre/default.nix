{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, powercap
, runCommand
, dieHook
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "scaphandre";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hubblo-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cXwgPYTgom4KrL/PH53Fk6ChtALuMYyJ/oTrUKHCrzE=";
  };

  cargoSha256 = "sha256-Vdkq9ShbHWepvIgHPjhKY+LmhjS+Pl84QelgEpen7Qs=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkPhase = ''
    runHook preCheck

    # Work around to pass test due to non existing path
    # https://github.com/hubblo-org/scaphandre/blob/v0.5.0/src/sensors/powercap_rapl.rs#L29
    export SCAPHANDRE_POWERCAP_PATH="$(mktemp -d)/scaphandre"

    mkdir -p "$SCAPHANDRE_POWERCAP_PATH"

    runHook postCheck
  '';

  passthru.tests = {
    stdout = self: runCommand "${pname}-test" {
      buildInputs = [
        self
        dieHook
      ];
    } ''
      ${self}/bin/scaphandre stdout -t 4 > $out  || die "Scaphandre failed to measure consumption"
      [ -s $out ]
    '';
    vm = nixosTests.scaphandre;
  };

  meta = with lib; {
    description = "Electrical power consumption metrology agent";
    homepage = "https://github.com/hubblo-org/scaphandre";
    license = licenses.asl20;
    platforms = with platforms; [ "x86_64-linux"];
    maintainers = with maintainers; [ gaelreyrol ];
  };
}
