{ stdenv, fetchurl, intltool, pcre, libcap_ng, libcgroup
, libsepol, libselinux, libsemanage
, python, sepolgen }:
stdenv.mkDerivation rec {

  name = "policycoreutils-${version}";
  version = "2.1.13";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "1145nbpwndmhma08vvj1j75bjd8xhjal0vjpazlrw78iyc30y11l";
  };

  patchPhase = ''
    substituteInPlace po/Makefile --replace /usr/bin/install install
  '';

  buildInputs = [ intltool pcre libcap_ng libcgroup
    libsepol libselinux  libsemanage
    python sepolgen # ToDo? these are optional
  ];

  preBuild = ''
    mkdir -p "$out/lib" && cp -s "${libsepol}/lib/libsepol.a" "$out/lib"
  '';

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  NIX_LDFLAGS = "-lsepol -lpcre";

  makeFlags = "PREFIX=$(out) DESTDIR=$(out) LOCALEDIR=$(out)/share/locale";

  meta = with stdenv.lib; {
    description = "SELinux policy core utilities";
    license = licenses.gpl2;
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}

