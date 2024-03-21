{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, nix-update-script
, runCommand
, dieHook
, nixosTests
, testers
, scaphandre
}:

rustPlatform.buildRustPackage rec {
  pname = "scaphandre";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hubblo-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y3TZJJ6ypZGGIEApDqiID7xWOSFTVjNQeDSomR3v5gY=";
  };

  cargoPatches = [ ./cargo-version.patch ];

  cargoHash = "sha256-E8xNv6Krq60cKIpuS2wMzLe+d2oo0YW9smViyP29y7k=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkPhase = ''
    runHook preCheck

    # Work around to pass test due to non existing path
    # https://github.com/hubblo-org/scaphandre/blob/v1.0.0/src/sensors/powercap_rapl.rs#L34
    export SCAPHANDRE_POWERCAP_PATH="$(mktemp -d)/scaphandre"

    mkdir -p "$SCAPHANDRE_POWERCAP_PATH"

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
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
      version = testers.testVersion {
        inherit version;
        package = scaphandre;
        command = "scaphandre --version";
      };
    };
  };

  meta = with lib; {
    description = "Electrical power consumption metrology agent";
    homepage = "https://github.com/hubblo-org/scaphandre";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "scaphandre";
  };
}
