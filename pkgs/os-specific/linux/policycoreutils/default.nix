{ stdenv, fetchurl, gettext, libsepol, libselinux, libsemanage }:

stdenv.mkDerivation rec {
  pname = "policycoreutils";
  version = "2.9";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "0yqg5ws5gbl1cbn8msxdk1c3ilmmx58qg5dx883kqyq0517k8g65";
  };

  postPatch = ''
    # Fix install references
    substituteInPlace po/Makefile \
       --replace /usr/bin/install install --replace /usr/share /share
    substituteInPlace newrole/Makefile --replace /usr/share /share

    sed -i -e '39i#include <crypt.h>' run_init/run_init.c
  '';

  nativeBuildInputs = [ gettext ];
  buildInputs = [ libsepol libselinux libsemanage ];

  makeFlags = [
    "PREFIX=$(out)"
    "SBINDIR=$(out)/sbin"
    "ETCDIR=$(out)/etc"
    "BASHCOMPLETIONDIR=$out/share/bash-completion/completions"
    "LOCALEDIR=$(out)/share/locale"
    "MAN5DIR=$(out)/share/man/man5"
  ];

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
