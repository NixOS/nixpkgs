# a simple derivation for nyzme, a wIDS for the raspberry pi


{ stdenv, lib, fetchurl, jre }:
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
        description = "A program to detect attacks against wireless networks";
        license = stdenv.lib.licenses.sspl;
        #maintainers = with lib.maintainers; [ jakobu5 ];
    };
}
