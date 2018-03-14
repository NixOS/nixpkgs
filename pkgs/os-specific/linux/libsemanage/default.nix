{ stdenv, fetchurl, pkgconfig, bison, flex, libsepol, libselinux, bzip2, libaudit
, enablePython ? true, swig ? null, python ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libsemanage-${version}";
  version = "2.7";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "0xnlp1yg8b1aqc6kq3pss1i1nl06rfj4x4pyl5blasnf2ivlgs87";
  };

  nativeBuildInputs = [ bison flex ];
  buildInputs = [ libsepol libselinux ustr bzip2 libaudit ];

  NIX_CFLAGS_COMPILE = [
    "-fstack-protector-all"
    "-std=gnu89"
    # these were added to fix build with gcc7. review on update
    "-Wno-error=format-truncation"
    "-Wno-error=implicit-fallthrough"
  ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=$out")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("MAN3DIR=$out/share/man/man3")
    makeFlagsArray+=("MAN5DIR=$out/share/man/man5")
    makeFlagsArray+=("PYSITEDIR=$out/lib/${python.libPrefix}/site-packages")
  '';

  installTargets = [ "install" ] ++ optionals enablePython [ "install-pywrap" ];

  meta = libsepol.meta // {
    description = "Policy management tools for SELinux";
    license = stdenv.lib.licenses.lgpl21;
  };
}
