# a simple derivation for nyzme, a wIDS for the raspberry pi


{ stdenv, fetchurl, jre }:
stdenv.mkDerivation rec {
    name = "nzyme-${version}";
    version = "1.1.1";

    builder = ./builder.sh;

    src = fetchurl {
        url = "https://assets.nzyme.org/releases/nzyme-1.1.1.jar";
        sha256 = "1ygbblgqqwad389g2szabdacc218b4bvm240fk4l73x7w8halr9b";
    };

    buildInputs = [ ];
    unpackPhase = "";
    inherit jre;

    meta = {
        homepage = "https://www.nzyme.org/";
        description = "The nzyme project uses WiFi adapters in monitor mode to scan the frequencies for suspicious behavior, specifically rogue access points and known WiFi attack platforms.";
        license = stdenv.lib.licenses.sspl;
    };
}
