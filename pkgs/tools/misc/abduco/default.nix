{ stdenv, fetchurl, writeText, conf? null}:

with stdenv.lib;

stdenv.mkDerivation rec {
    name = "abduco-0.5";

    meta = {
        homepage = http://brain-dump.org/projects/abduco;
        license = licenses.isc;
        description = "Allows programs to be run independently from its controlling terminal";
        maintainers = with maintainers; [ pSub ];
        platforms = platforms.linux;
    };

    src = fetchurl {
        url = "http://www.brain-dump.org/projects/abduco/${name}.tar.gz";
        sha256 = "11phry5wnvwm9ckij5gxbrjfgdz3x38vpnm505q5ldc88im248mz";
    };

    configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
    preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

    installPhase = ''
      make PREFIX=$out install
    '';
}
