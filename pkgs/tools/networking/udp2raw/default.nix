{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, iptables
}:

stdenv.mkDerivation rec {
  pname = "udp2raw";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "udp2raw";
    rev = version;
    hash = "sha256-mchSaqw6sOJ7+dydCM8juP7QMOVUrPL4MFA79Rvyjdo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "dynamic" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp udp2raw_dynamic $out/bin/udp2raw
    wrapProgram $out/bin/udp2raw --prefix PATH : "${lib.makeBinPath [ iptables ]}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/wangyu-/udp2raw";
    description = "A tunnel which turns UDP traffic into encrypted UDP/FakeTCP/ICMP traffic by using a raw socket";
    license = licenses.mit;
    changelog = "https://github.com/wangyu-/udp2raw/releases/tag/${version}";
    maintainers = with maintainers; [ chvp ];
    platforms = platforms.linux;
  };
}
