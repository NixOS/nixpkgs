{ lib, bash, buildGoModule, fetchFromGitHub, getent, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bWdkuw0uEE75l9YCo2Dq1NpWXuMH61RQ6p7m65P1QCE=";
  };

  vendorHash = "sha256-IJ2Gq5z1oNvcpWPh+BMs46VZMN1lHyE+M7kUinTSRr8=";

  preCheck = ''
    ln -s $GOPATH/bin/otel-cli .
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace main_test.go \
      --replace 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${lib.makeBinPath [ getent ]}`'
  '';

  meta = with lib; {
    homepage = "https://github.com/equinix-labs/otel-cli";
    description = "A command-line tool for sending OpenTelemetry traces";
    changelog = "https://github.com/equinix-labs/otel-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ emattiza urandom ];
  };
}
