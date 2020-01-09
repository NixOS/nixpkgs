{ stdenv
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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1hw9fazf5m80p39wgjqjcxafkfjxh0rkjmiznn2p66gccjnkddm6";
  };

  cargoSha256 = "17hx02g9m3l2kgxba0n6wmixdbd9g8443h085v8shd70c6vln2v8";

  nativeBuildInputs = [ pkg-config ]
    ++ stdenv.lib.optionals (withStableFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ stdenv.lib.optionals (withStableFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ stdenv.lib.optionals (withStableFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = stdenv.lib.optional withStableFeatures "--features=stable";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 marsam ];
    platforms = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
