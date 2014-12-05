{ stdenv, fetchurl, writeText, conf? null}:

with stdenv.lib;

stdenv.mkDerivation rec {
    name = "abduco-0.2";

    meta = {
        homepage = http://brain-dump.org/projects/abduco;
        license = licenses.isc;
        description = "Allows programs to be run independently from its controlling terminal";
        platforms = with platforms; linux;
    };

    src = fetchurl {
        url = "http://www.brain-dump.org/projects/abduco/${name}.tar.gz";
        sha256 = "04hrlxb02h2j8vxjnj263slyzxgkf7sncxfm0iwds5097f85mdy8";
    };

    configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
    preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

    buildInputs = [];

    installPhase = ''
      make PREFIX=$out install
    '';
}
