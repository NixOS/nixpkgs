{stdenvNoCC, fetchFromGitHub, ...}:

stdenvNoCC.mkDerivation rec {
    pname = "steam-devices";
    version = "20210825";

    src = fetchFromGitHub{
        owner = "ValveSoftware";
        repo = "steam-devices";
        rev = "d87ef558408c5e7a1a793d738db4c9dc2cb5f8fa";
        sha256 = "pNAmXfj7PK/QHypSYFKCTSl7+rrCFlVRACm49FV+Efs=";
    };

    installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp *.rules $out/lib/udev/rules.d
    '';
}
