{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ion";
  version = "unstable-2022-11-27";

  src = fetchFromGitHub {
    owner = "redox-os";
    repo = "ion";
    rev = "3bb8966fc99ba223033e1e02b0a6d50fc25cbef4";
    sha256 = "sha256-6KW/YkMQFeGb1i+1YdADZRW89UruHsfPhMq9Cvxjl/4=";
  };

  cargoSha256 = "sha256-KLKPnj4SmAuspjMPAGLJ8Yy9SxAi6FvGE/FIF58lAH8=";

  patches = [
    # remove git revision from the build script to fix build
    ./build-script.patch
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = lib.optionals stdenv.isDarwin [
    # test assumes linux
    "--skip=binary::completer::tests::filename_completion"
  ];

  passthru = {
    shellPath = "/bin/ion";
  };

  meta = with lib; {
    description = "Modern system shell with simple (and powerful) syntax";
    homepage = "https://gitlab.redox-os.org/redox-os/ion";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
  };
}
