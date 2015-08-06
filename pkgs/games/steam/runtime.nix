{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "steam-runtime-${version}";
  version = "2014-04-15";

  phases = [ "unpackPhase" "installPhase" ];

  src = fetchurl {
    url = "http://media.steampowered.com/client/runtime/steam-runtime-release_${version}.tar.xz";
    sha256 = "0i6xp81rjbfn4664h4mmvw0xjwlwvdp6k7cc53jfjadcblw5cf99";
  };

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = with stdenv.lib; {
    description = "The official runtime used by Steam";
    homepage = http://store.steampowered.com/;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ hrdinka ];
  };
}
