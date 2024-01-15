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

let
  version = "0.89.0";
in

rustPlatform.buildRustPackage {
  pname = "nushell";
  inherit version;

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    hash = "sha256-sBS24FOdEhb+MPu33lpFxLd2/r2AvLUXka+7W3lUIvo=";
  };

  cargoHash = "sha256-B1Sd4dLacIIVNQDnBFw74nX+LaQnzYwCKXv3oJIbu4M=";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ python3 ]
    ++ lib.optionals stdenv.isDarwin [ rustPlatform.bindgenHook ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals stdenv.isDarwin [ zlib Libsystem Security ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withDefaultFeatures && stdenv.isDarwin) [ AppKit nghttp2 libgit2 ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  inherit doCheck;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
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

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    mainProgram = "nu";
  };
}
