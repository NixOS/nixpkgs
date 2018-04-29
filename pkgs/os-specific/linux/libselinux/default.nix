{ stdenv, fetchurl, pcre, pkgconfig, libsepol
, enablePython ? true, swig ? null, python ? null
, musl-fts
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.7";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "0mwcq78v6ngbq06xmb9dvilpg0jnl2vs9fgrpakhmmiskdvc1znh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsepol pcre ]
             ++ optionals enablePython [ swig python ]
             ++ optional stdenv.hostPlatform.isMusl musl-fts;

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  postPatch = optionalString enablePython ''
    sed -i -e 's|\$(LIBDIR)/libsepol.a|${libsepol}/lib/libsepol.a|' src/Makefile
  '';

  # fix install locations
  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("MAN3DIR=$out/share/man/man3")
    makeFlagsArray+=("MAN5DIR=$out/share/man/man5")
    makeFlagsArray+=("MAN8DIR=$out/share/man/man8")
    makeFlagsArray+=("PYSITEDIR=$out/lib/${python.libPrefix}/site-packages")
  '';

  installTargets = [ "install" ] ++ optional enablePython "install-pywrap";

  meta = libsepol.meta // {
    description = "SELinux core library";
  };
}
