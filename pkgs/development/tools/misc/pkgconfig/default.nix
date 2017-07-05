{stdenv, fetchurl, automake, libiconv, vanilla ? false }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "pkg-config-0.29.2";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    urls = [
      "https://pkgconfig.freedesktop.org/releases/${name}.tar.gz"
      "http://fossies.org/linux/misc/${name}.tar.gz"
    ];
    sha256 = "14fmwzki1rlz8bs2p810lk6jqdxsk966d8drgsjmi54cd00rrikg";
  };
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
  patches = optional (!vanilla) ./requires-private.patch
    ++ optional stdenv.isCygwin ./2.36.3-not-win32.patch;

  preConfigure = optionalString (stdenv.system == "mips64el-linux")
    ''cp -v ${automake}/share/automake*/config.{sub,guess} .'';
  buildInputs = optional (stdenv.isCygwin || stdenv.isDarwin || stdenv.isSunOS) libiconv;

  configureFlags = [ "--with-internal-glib" ]
    ++ optional (stdenv.isSunOS) [ "--with-libiconv=gnu" "--with-system-library-path" "--with-system-include-path" "CFLAGS=-DENABLE_NLS" ];

  postInstall = ''rm -f "$out"/bin/*-pkg-config''; # clean the duplicate file

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://pkg-config.freedesktop.org/wiki/;
    platforms = platforms.all;
  };

}

