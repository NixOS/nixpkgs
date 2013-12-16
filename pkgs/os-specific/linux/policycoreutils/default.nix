{ stdenv, fetchurl, intltool, pcre, libcap_ng, libcgroup
, libsepol, libselinux, libsemanage, setools
, python, sepolgen }:
stdenv.mkDerivation rec {

  name = "policycoreutils-${version}";
  version = "2.2.5";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "1i0chc3km3wdgzrd556mmhvsglydxrimclnn77s73wy2qfl51y5v";
  };

  patchPhase = ''
    substituteInPlace po/Makefile --replace /usr/bin/install install
    find . -type f -exec sed -i 's,/usr/bin/python,${python}/bin/python,' {} \;
  '';

  buildInputs = [ intltool pcre libcap_ng libcgroup
    libsepol libselinux libsemanage setools
    python sepolgen # ToDo? these are optional
  ];

  preBuild = ''
    mkdir -p "$out/lib" && cp -s "${libsepol}/lib/libsepol.a" "$out/lib"
  '';

  # Creation of the system-config-selinux directory is broken
  preInstall = ''
    mkdir -p $out/share/system-config-selinux
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

