{ stdenv, fetchurl, pcre, pkgconfig, libsepol
, enablePython ? true, swig ? null, python ? null
, fts
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "libselinux";
  version = "2.9";
  inherit (libsepol) se_release se_url;

  outputs = [ "bin" "out" "dev" "man" ] ++ optional enablePython "py";

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "14r69mgmz7najf9wbizvp68q56mqx4yjbkxjlbcqg5a47s3wik0v";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optionals enablePython [ swig python ];
  buildInputs = [ libsepol pcre fts ] ++ optionals enablePython [ python ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  makeFlags = [
    "PREFIX=$(out)"
    "INCDIR=$(dev)/include/selinux"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "MAN8DIR=$(man)/share/man/man8"
    "PYTHON=python"
    "PYTHONLIBDIR=$(py)/${python.sitePackages}"
    "SBINDIR=$(bin)/sbin"
    "SHLIBDIR=$(out)/lib"

    "LIBSEPOLA=${stdenv.lib.getLib libsepol}/lib/libsepol.a"
  ];

  installTargets = [ "install" ] ++ optional enablePython "install-pywrap";

  meta = removeAttrs libsepol.meta ["outputsToInstall"] // {
    description = "SELinux core library";
  };
}
