{ fetchurl, stdenv, guile, libgcrypt, sqlite, bzip2, pkgconfig }:

let
  # Getting the bootstrap Guile binary.  This is normally performed by Guix's build system.
  base_url = arch:
    "http://alpha.gnu.org/gnu/guix/bootstrap/${arch}-linux/20130105/guile-2.0.7.tar.xz";
  boot_guile = {
    i686 = fetchurl {
      url = base_url "i686";
      sha256 = "f9a7c6f4c556eaafa2a69bcf07d4ffbb6682ea831d4c9da9ba095aca3ccd217c";
    };
    x86_64 = fetchurl {
      url = base_url "x86_64";
      sha256 = "bc43210dcd146d242bef4d354b0aeac12c4ef3118c07502d17ffa8d49e15aa2c";
    };
  };
in stdenv.mkDerivation rec {
  name = "guix-0.3";

  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/guix/${name}.tar.gz";
    sha256 = "0xpfdmlfkkpmgrb8lpaqs5wxx31m4jslajs6b9waz5wp91zk7fix";
  };

  configureFlags =
     [ "--localstatedir=/nix/var"
       "--with-libgcrypt-prefix=${libgcrypt}"
     ];

  preBuild =
    # Copy the bootstrap Guile tarballs like Guix's makefile normally does.
    '' cp -v "${boot_guile.i686}" gnu/packages/bootstrap/i686-linux/guile-2.0.7.tar.xz
       cp -v "${boot_guile.x86_64}" gnu/packages/bootstrap/x86_64-linux/guile-2.0.7.tar.xz
    '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile libgcrypt sqlite bzip2 ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = {
    description = "Functional package manager with a Scheme interface";

    longDescription = ''
      GNU Guix is a purely functional package manager for the GNU system, and a distribution thereof.

      In addition to standard package management features, Guix supports
      transactional upgrades and roll-backs, unprivileged package management,
      per-user profiles, and garbage collection.

      It provides Guile Scheme APIs, including high-level embedded
      domain-specific languages (EDSLs), to describe how packages are built
      and composed.

      A user-land free software distribution for GNU/Linux comes as part of
      Guix.

      Guix is based on the Nix package manager.
    '';

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;

    homepage = http://www.gnu.org/software/guix;
  };
}
