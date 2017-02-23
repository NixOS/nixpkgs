{ stdenv, fetchurl, lib, undmg }:

stdenv.mkDerivation rec {
  version = "1476379980";
  name = "steam-${version}";

  src = fetchurl {
    url = "https://steamcdn-a.akamaihd.net/client/installer/steam.dmg";
    sha256 = "1xmc4qiqgdm8vslm8p890mh1b0dbdkc8cbjwf6bl9i0bcf3g8v6a";
  };

  nativeBuildInputs = [ undmg ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/Applications
    cp -r . $out/Applications/Steam.app
  '';

  meta = with lib; {
    description = "A digital distribution platform";
    homepage = http://store.steampowered.com/;
    license = licenses.unfreeRedistributable;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ jagajaga ];
  };
}
