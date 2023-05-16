<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub, getent, coreutils, nix-update-script, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.4.0";
=======
{ lib, bash, buildGoModule, fetchFromGitHub, getent, nix-update-script, stdenv }:

buildGoModule rec {
  pname = "otel-cli";
  version = "0.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "equinix-labs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xIvxjmrZd/2eT2JAagH+mMyYkDjc7La5dUqsmNnOtrc=";
  };

  vendorHash = "sha256-mnMtvR2r5HbKC0P5iGFkwLcpx3IvmhgCI8/CCVJunXw=";
=======
    hash = "sha256-hez/jHet7W4FnOjgLb0jE1FhoNimiLGaOuTI44UWbSA=";
  };

  vendorHash = "sha256-gVRgqBgiFnPU6MRZi/Igs7nDPMwJYsdln7vPAcxTvPU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preCheck = ''
    ln -s $GOPATH/bin/otel-cli .
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace main_test.go \
<<<<<<< HEAD
      --replace 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${lib.makeBinPath [ getent coreutils ]}`'
=======
      --replace 'const minimumPath = `/bin:/usr/bin`' 'const minimumPath = `${lib.makeBinPath [ getent ]}`'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
