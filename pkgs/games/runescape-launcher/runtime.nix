{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  name = "runescape-launcher-runtime-${version}";
  version = "2.2.4";

  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_${version}_amd64.deb";
    sha256 = "0yab34widf3j4s6lhn6w1q76kihrbyphmr4ifkkawg10csd0n17l";
  };

  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [ dpkg ];
  unpackCmd = "dpkg -x $curSrc .";

  installPhase = ''
    cp -r . $out
    substituteInPlace $out/bin/runescape-launcher --replace /usr/share $out/share
  '';

  meta = with stdenv.lib; {
    description = "Runescape NXT client";
    homepage = https://www.runescape.com;
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
