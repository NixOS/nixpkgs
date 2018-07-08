{ stdenv, fetchurl
, autoreconfHook
, git
, gnumake
, gnutls
, guile
, guile-git
, guile-json
, guile-sqlite3
, lbzip2
, libgcrypt
, nix
, pkgconfig
, zlib
}:
let
  guile-gnutls = gnutls.override { guileBindings = true; };
in
stdenv.mkDerivation rec {
  name = "guix-${version}";
  version = "0.15.0";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/guix/guix-${version}.tar.gz";
    sha256 = "07fbjgqb5hg2b9s5z2sg1g4fqfrap5x6jxkdah0i5qbgip9p45ap";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  buildInputs = [
    git
    gnumake
    guile
    guile-git
    guile-json
    guile-sqlite3
    guile-gnutls
    lbzip2
    libgcrypt
    nix
    zlib
  ];

  preConfigure = ''
    env | grep GUILE
    echo DDDDDDDDDDDDDDDDDDDDDEBUGGGGGGGG
    guile -c '(display %load-path) (newline)'
    echo DDDDDDDDDDDDDDDDDDDDDEBUGGGGGGGG
    guile -c '(display %load-compiled-path) (newline)'
  '';



  # Already provided by the nix-daemon
  configureFlags = [ "--disable-daemon" ];
}
