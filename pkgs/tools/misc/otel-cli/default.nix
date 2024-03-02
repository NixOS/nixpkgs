{ lib, buildGoModule, fetchFromGitHub, getent, coreutils, nix-update-script, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kOTReHG7byOqKsaVrXXNq9DAyawTz4hUeR4Q5lJKmiM=";
  };

  vendorHash = "sha256-HwbEqWtOqiTe5Z/MtMAs63Lzvll/vgmbCpMTREXgtXA=";

  preCheck = ''
    ln -s $GOPATH/bin/otel-cli .
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace main_test.go \
      --replace 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${lib.makeBinPath [ getent coreutils ]}`'
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://github.com/equinix-labs/otel-cli";
    description = "A command-line tool for sending OpenTelemetry traces";
    changelog = "https://github.com/equinix-labs/otel-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ emattiza urandom ];
    mainProgram = "otel-cli";
  };
}
