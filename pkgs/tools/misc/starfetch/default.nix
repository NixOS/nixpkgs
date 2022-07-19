{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "starfetch";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "Haruno19";
    repo = "starfetch";
    rev = version;
    sha256 = "sha256-waJ1DbOqhZ3hHtqcODSXBC+O46S8RSxuBuoEqs8OfgI=";
  };

  postPatch = ''
    substituteInPlace src/starfetch.cpp --replace /usr/local/ $out/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/starfetch
    cp starfetch $out/bin/
    cp -r res/* $out/share/starfetch/

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI star constellations displayer";
    homepage = "https://github.com/Haruno19/starfetch";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ annaaurora ];
  };
}
