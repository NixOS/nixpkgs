{
  lib,
  stdenv,
  fetchFromGitHub,
  iproute2,
  runtimeShell,
  systemd,
  coreutils,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "update-systemd-resolved";
  # when updating this, check if additional binaries need injecting into PATH
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonathanio";
    repo = "update-systemd-resolved";
    rev = "v${version}";
    hash = "sha256-lYJTR3oBmpENcqNHa9PFXsw7ly6agwjBWf4UXf1d8Kc=";
  };

  # set SCRIPT_NAME in case we are wrapped and inject PATH
  patches = [
    ./update-systemd-resolved.patch
  ];

  PREFIX = "${placeholder "out"}/libexec/openvpn";

  postInstall = ''
    substituteInPlace ${PREFIX}/update-systemd-resolved \
      --subst-var-by PATH ${
        lib.makeBinPath [
          coreutils
          iproute2
          runtimeShell
          systemd
          util-linux
        ]
      }
  '';

  meta = with lib; {
    description = "Helper script for OpenVPN to directly update the DNS settings of a link through systemd-resolved via DBus";
    homepage = "https://github.com/jonathanio/update-systemd-resolved";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ eadwu ];
    platforms = platforms.linux;
  };
}
