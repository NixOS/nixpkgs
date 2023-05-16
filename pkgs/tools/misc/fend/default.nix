{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, pandoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "fend";
<<<<<<< HEAD
  version = "1.2.0";
=======
  version = "1.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-vV7P2e6kv6CCHbI5Roz9WElntl3t/5ySXUw3XXEXMv4=";
  };

  cargoHash = "sha256-oAkZHx33YrwRUUIoooqpy72QCq0ZkAgBZ8W8XDe2fNE=";
=======
    sha256 = "sha256-PO8QKZwtiNMlEFT2P61oe5kj6PWsP5uouOOTRtvpyxI=";
  };

  cargoHash = "sha256-og2YoPUKKMBqEjryzSGqwLIm44WfKkerNtG2N7yl1wE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pandoc installShellFiles ];
  buildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postBuild = ''
    patchShebangs --build ./documentation/build.sh
    ./documentation/build.sh
  '';

  preFixup = ''
    installManPage documentation/fend.1
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
