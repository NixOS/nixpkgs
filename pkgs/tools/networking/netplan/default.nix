{ stdenv
, fetchFromGitHub
, glib
, libuuid
, libyaml
, pandoc
, pkgconfig
, python3
, systemd
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "netplan";
  version = "0.98+git20191004";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = "netplan";
    rev = "a5397e60df489dcbbb476e610b08e01ed6aaecbf";
    sha256 = "0hi1n6zxcm02a5zn47kk02km4p892fb9q5ycsgfhcvf32i6p3jji";
  };

  nativeBuildInputs = [
    makeWrapper
    pandoc
    pkgconfig
  ];
  buildInputs = [
    glib
    libuuid
    libyaml
    systemd
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ROOTPREFIX=${placeholder "out"}"
    "SYSTEMD_GENERATOR_DIR=${placeholder "out"}/lib/systemd/system-generators/"
    "SYSTEMD_UNIT_DIR=${placeholder "out"}/lib/systemd/units/"
    "BASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  postPatch = ''
    sed -e 's,SYSTEMD_GENERATOR_DIR=,SYSTEMD_GENERATOR_DIR ?= ,' \
        -e 's,SYSTEMD_UNIT_DIR=,SYSTEMD_UNIT_DIR ?= ,' \
        -e 's,BASH_COMPLETIONS_DIR=,BASH_COMPLETIONS_DIR ?= ,' \
        -i Makefile
  '';

  postFixup = let
    pythonEnv = python3.withPackages (p: with p; [ pyyaml netifaces ]);
  in ''
    wrapProgram $out/bin/netplan \
      --set PYTHONPATH "${pythonEnv}/${python3.sitePackages}"
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    homepage = "http://netplan.io";
    description = "Backend-agnostic network configuration in YAML";
    platforms = platforms.unix;
  };
}
