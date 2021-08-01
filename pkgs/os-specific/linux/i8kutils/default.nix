{ lib, stdenv, fetchFromGitHub, tcl }:

stdenv.mkDerivation rec {
  pname = "i8kutils";
  version = "c993fb1da1bba5c2cd2860c1aa6c3916b4de77e4";

  src = fetchFromGitHub {
    owner = "vitorafsr";
    repo = "i8kutils";
    rev = version;
    sha256 = "0dlfv5chc7izqg0rbllw32i3my3sv229mrz1qgwxc01ghbip00y8";
  };

  buildInputs = [ tcl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp i8kctl $out/bin/i8kctl
    sed "s|I8KCTL=/usr/bin/i8kctl|I8KCTL=$out/bin/i8kctl|g" i8kfan > $out/bin/i8kfan
    sed "s|i8kfan       /usr/bin/i8kfan|i8kfan       $out/bin/i8kfan|g" i8kmon > $out/bin/i8kmon
    chmod +rx $out/bin/i8kfan $out/bin/i8kmon

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools to control and monitor fans on some Dell laptops";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rowanG077 ];
  };
}
