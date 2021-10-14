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
  version = "0.103";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "netplan";
    rev = version;
    hash = "sha256-d8Ze8S/w2nyJkATzLfizMqmr7ad2wrK1mjADClee6WE=";
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

    # from upstream https://github.com/canonical/netplan/blob/ee0d5df7b1dfbc3197865f02c724204b955e0e58/rpm/netplan.spec#L81
    sed -e "s/-Werror//g" -i Makefile
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
