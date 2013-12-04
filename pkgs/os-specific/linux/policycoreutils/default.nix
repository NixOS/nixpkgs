{ stdenv, fetchurl, intltool, pcre, libcap_ng, libcgroup
, libsepol, libselinux, libsemanage, setools
, python, sepolgen }:
stdenv.mkDerivation rec {

  name = "policycoreutils-${version}";
  version = "2.2.4";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/policycoreutils-${version}.tar.gz";
    sha256 = "08zpd2a2j45j1qkmq9sz084r2xr0fky1cnld45sn8w5xgdw8k81n";
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

