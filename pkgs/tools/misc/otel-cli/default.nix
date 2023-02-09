{ lib, bash, buildGoModule, fetchFromGitHub, getent, nix-update-script, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iYlyokBAS5KQUYq83zhKWH/Vulq7prQdceFpeBJN2PI=";
  };

  vendorHash = "sha256-5c5uDp5KVo/DYAM5F76ivtT52+lNBheVmjAjmq6EJFk=";

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
