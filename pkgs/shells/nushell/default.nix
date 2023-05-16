{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zlib
, zstd
, pkg-config
, python3
, xorg
<<<<<<< HEAD
=======
, libiconv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, Libsystem
, AppKit
, Security
, nghttp2
, libgit2
, doCheck ? true
, withDefaultFeatures ? true
, additionalFeatures ? (p: p)
, testers
, nushell
, nix-update-script
}:

<<<<<<< HEAD
let
  version = "0.84.0";
in

rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    hash = "sha256-vXtQUWKRPS53IBUgO9Dw8dVzfD5W2kHSPOZHs293O5Q=";
  };

  cargoHash = "sha256-NtTCuTWbGTrGKF7ulm3Bfal/WuBtPEX7QvHoOyKY1V8=";
=======
rustPlatform.buildRustPackage (
  let
    version =  "0.79.0";
    pname = "nushell";
  in {
  inherit version pname;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-vnOTSXTgFxNTI4msgMQ/5E27VUKPj6nBIqPWLUeXAr4=";
  };

  cargoHash = "sha256-FqhN1t3n6j5czZ40JUFtsz4ZxTl7vpMTBhrR66M1DNw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ python3 ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [ openssl zstd ]
<<<<<<< HEAD
    ++ lib.optionals stdenv.isDarwin [ zlib Libsystem Security ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  inherit doCheck;
=======
    ++ lib.optionals stdenv.isDarwin [ zlib libiconv Libsystem Security ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildFeatures = additionalFeatures [ (lib.optional withDefaultFeatures "default") ];

  # TODO investigate why tests are broken on darwin
  # failures show that tests try to write to paths
  # outside of TMPDIR
  doCheck = doCheck && !stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
<<<<<<< HEAD
    HOME=$(mktemp -d) cargo test
    runHook postCheck
  '';

  passthru = {
    shellPath = "/bin/nu";
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };

=======
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    mainProgram = "nu";
  };
<<<<<<< HEAD
}
=======

  passthru = {
    shellPath = "/bin/nu";
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
