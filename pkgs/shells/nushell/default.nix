{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, python3
, xorg
, libiconv
, AppKit
, Security
, withStableFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "100r26dx57wdzdpf6lgsgw0py33k3nsx73pa1qjcipwv00a106sr";
  };

  cargoSha256 = "0ch79zsnqb5n9r7jq6figpmqp2cs2p9a3m7fg3sd04m797ki9chr";

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = lib.optional withStableFeatures "--features stable";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 johntitor marsam ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
