{ lib, stdenv, fetchFromGitHub
, makeWrapper
, iproute, systemd, coreutils, utillinux }:

stdenv.mkDerivation rec {
  pname = "update-systemd-resolved";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonathanio";
    repo = "update-systemd-resolved";
    rev = "v${version}";
    sha256 = "19zhbpyms57yb70hi0ws5sbkpk2yqp9nnix3f86r36h1g93m70lm";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildFlags = [
    "PREFIX=${placeholder "out"}/libexec/openvpn"
  ];

  installPhase = ''
    wrapProgram $out/libexec/openvpn/update-systemd-resolved \
      --prefix PATH : ${lib.makeBinPath [ iproute systemd coreutils utillinux ]}
  '';

  meta = with stdenv.lib; {
    description = "Helper script for OpenVPN to directly update the DNS settings of a link through systemd-resolved via DBus";
    homepage = https://github.com/jonathanio/update-systemd-resolved;
    maintainers = with maintainers; [ eadwu ];
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
