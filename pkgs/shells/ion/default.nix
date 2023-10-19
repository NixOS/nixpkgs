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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "calculate-0.7.0" = "sha256-wUmi8XLgEMgECeaCM0r1KxJ+oTd47QozgFBANKSwt24=";
      "decimal-2.1.0" = "sha256-s5mDRCkaDBUdaywYEJzTfe7qH25sG5UUo5iVmPE+zrw=";
      "nix-0.23.1" = "sha256-yWJYrQt9piJHhqBkH/hn9dsXR8oqzl0RKPrzx9fvqlw=";
      "object-pool-0.5.3" = "sha256-LWP0b62sk2dcqnQEEvLmZVvWSVLJ722yH/zIIPL93W4=";
      "redox_liner-0.5.1" = "sha256-OT9E4AwQgm5NngcCtcno1VKhkS4d8Eq/l+8aYHvXtTY=";
      "small-0.1.0" = "sha256-QIzEfFc0EDEllf+YxVyV7j/PvC7nVWiK0YYBoZBQZ3Q=";
      "termion-1.5.6" = "sha256-NTY/2SbqkSyslnN5Xg6lrQ0MTrOhTMHqN+XXqN6Nkr8=";
    };
  };

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
