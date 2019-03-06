{ stdenv, fetchurl, pkgconfig, bison, flex, libsepol, libselinux, bzip2, audit
, enablePython ? true, swig ? null, python ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libsemanage-${version}";
  version = "2.8";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libsemanage-${version}.tar.gz";
    sha256 = "1qm8pr67w08xrkqfky6qvy3r18w4bh873qr1dj960m0yqp9fh38w";
  };

  nativeBuildInputs = [ bison flex pkgconfig ];
  buildInputs = [ libsepol libselinux bzip2 audit ]
    ++ optionals enablePython [ swig python ];

  preBuild = ''
    makeFlagsArray+=("PREFIX=/")
    makeFlagsArray+=("DESTDIR=$out")
    makeFlagsArray+=("PYTHONLIBDIR=lib/${python.libPrefix}/site-packages")
  '';

  installTargets = [ "install" ] ++ optionals enablePython [ "install-pywrap" ];

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "Policy management tools for SELinux";
    license = stdenv.lib.licenses.lgpl21;
  };
}
