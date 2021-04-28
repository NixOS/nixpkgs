{ stdenv
, fetchFromGitHub
, pkg-config
, glib
, pandoc
, systemd
, libyaml
, python3
, libuuid
, bash-completion
, lib
}:

stdenv.mkDerivation rec {
  pname = "netplan";
  version = "0.101";

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = "netplan";
    rev = version;
    hash = "sha256-bCK7J2pCQUwjZu8c1n6jhF6T/gvUGwydqAXpxUMLgMc=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [
    pkg-config
    glib
    pandoc
  ];

  buildInputs = [
    systemd
    glib
    libyaml
    (python3.withPackages (p: with p; [ pyyaml netifaces ]))
    libuuid
    bash-completion
  ];

  postPatch = ''
    substituteInPlace netplan/cli/utils.py --replace "/lib/netplan/generate" "$out/lib/netplan/generate"
    substituteInPlace netplan/cli/utils.py --replace "ctypes.util.find_library('netplan')" "\"$out/lib/libnetplan.so\""

    substituteInPlace Makefile --replace 'SYSTEMD_GENERATOR_DIR=' 'SYSTEMD_GENERATOR_DIR ?= ' \
        --replace 'SYSTEMD_UNIT_DIR=' 'SYSTEMD_UNIT_DIR ?= ' \
        --replace 'BASH_COMPLETIONS_DIR=' 'BASH_COMPLETIONS_DIR ?= '
  '';

  makeFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
    "SYSTEMD_GENERATOR_DIR=lib/systemd/system-generators/"
    "SYSTEMD_UNIT_DIR=lib/systemd/units/"
    "BASH_COMPLETIONS_DIR=share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "Backend-agnostic network configuration in YAML";
    homepage = "https://netplan.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
