{ stdenv, fetchurl, writeText, conf? null}:

with stdenv.lib;

stdenv.mkDerivation rec {
    name = "abduco-0.6";

    meta = {
        homepage = http://brain-dump.org/projects/abduco;
        license = licenses.isc;
        description = "Allows programs to be run independently from its controlling terminal";
        maintainers = with maintainers; [ pSub ];
        platforms = platforms.linux;
    };

    src = fetchurl {
        url = "http://www.brain-dump.org/projects/abduco/${name}.tar.gz";
        sha256 = "1x1m58ckwsprljgmdy93mvgjyg9x3cqrzdf3mysp0mx97zhhj2f9";
    };

    configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
    preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

    installPhase = ''
      make PREFIX=$out install
    '';
}
