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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "f9da7f7d58da3ead2aaba6a519c554d1b199c158"; # 0.7.1 on crates.io
    sha256 = "0k662wq2m3xfnzkkrsiv5h2m9y3l44fr3gab933ggrdgj2xydqnh";
  };

  cargoSha256 = "0bdxlbl33kilp9ai40dvdzlx9vcl8r21br82r5ljs2pg521jd66p";

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
