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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "09kcyvhnhf5qsaivgrw58l9jh48rx40i9lkf10cpmk7jvqxgqyks";
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
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
