{ lib, bash, buildGoModule, fetchFromGitHub, getent, nix-update-script, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hez/jHet7W4FnOjgLb0jE1FhoNimiLGaOuTI44UWbSA=";
  };

  vendorHash = "sha256-gVRgqBgiFnPU6MRZi/Igs7nDPMwJYsdln7vPAcxTvPU=";

  preCheck = ''
    ln -s $GOPATH/bin/otel-cli .
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace main_test.go \
      --replace 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${lib.makeBinPath [ getent ]}`'
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    homepage = "https://github.com/equinix-labs/otel-cli";
    description = "A command-line tool for sending OpenTelemetry traces";
    changelog = "https://github.com/equinix-labs/otel-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ emattiza urandom ];
  };
}
