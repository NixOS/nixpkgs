{ lib, stdenv, openjdk, fetchTarball }:

stdenv.mkDerivation rec {
    pname = "grakn";
    version = "1.8.4";

    linux_src = fetchTarball {
        url = "https://github.com/graknlabs/grakn/releases/download/2.0.0-alpha-9/grakn-core-all-linux-2.0.0-alpha-9.tar.gz";
        sha3 = "813dce8b2e3eccc81430dfd7f6825597af46450f";
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
        #changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${version}";
        license = licenses.gpl3Plus;
        #maintainers = [ maintainers.eelco ];
        platforms = platforms.all;
    };
}
