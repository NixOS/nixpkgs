{ stdenv, fetchurl }:

let version = "3.2"; in

stdenv.mkDerivation {
    name = "entr-${version}";
    src = fetchurl {
        url = "http://entrproject.org/code/${name}-${version}.tar.gz";
        sha256 = "0ikigpfzyjmr8j6snwlvxzqamrjbhlv78m8w1h0h7kzczc5f1vmi";
    };

    enableParallelBuilding = true;

    meta = {
        homepage = "http://http://entrproject.org/";
        description = "Run arbitrary commands when files change";
        platforms = stdenv.lib.platforms.all;
    };
}
