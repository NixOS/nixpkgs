{ stdenv, fetchurl, pcre, pkgconfig, libsepol
, enablePython ? true, swig ? null, python ? null
, fts
}:

assert enablePython -> swig != null && python != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.8";
  inherit (libsepol) se_release se_url;

  outputs = [ "bin" "out" "dev" "man" "py" ];

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "1qc7c6lzvhs9sdgqalg1rxni3a88d989hgrw5f8i1kj3fvn9dnri";
  };

  nativeBuildInputs = [ pkgconfig ] ++ optionals enablePython [ swig python ];
  buildInputs = [ libsepol pcre fts ] ++ optionals enablePython [ python ];

  # drop fortify here since package uses it by default, leading to compile error:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]
  hardeningDisable = [ "fortify" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  makeFlags = [
    "PREFIX=$(out)"
    "INCDIR=$(dev)/include/selinux"
    "INCLUDEDIR=$(dev)/include"
    "MAN3DIR=$(man)/share/man/man3"
    "MAN5DIR=$(man)/share/man/man5"
    "MAN8DIR=$(man)/share/man/man8"
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
