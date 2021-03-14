{ lib, stdenv, openjdk, fetchurl }:

stdenv.mkDerivation rec {
    pname = "grakn";
    version = "1.8.4";

    src = fetchurl {
        url = "https://github.com/graknlabs/grakn/releases/download/2.0.0-alpha-9/grakn-core-all-linux-2.0.0-alpha-9.tar.gz";
        sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
    };

    buildDepends = [ openjdk ];

    doCheck = true;

    meta = with lib; {
        description = "Grakn Core: The Knowledge Graph";
        longDescription = ''
            Grakn is a distributed knowledge graph: 
            a logical database to organise large and 
            complex networks of data as one body of knowledge.
        '';
        homepage = "https://www.grakn.ai/";
        license = licenses.gpl3Plus;
        platforms = platforms.all;
    };
}
