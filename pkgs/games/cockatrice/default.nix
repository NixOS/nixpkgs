{ stdenv, fetchurl, cmake, qtbase, qtmultimedia, protobuf, qttools
}:

stdenv.mkDerivation rec {
    name = "${pname}-unstable-${version}";
    pname = "cockatrice";
    version = "2017-01-20";

    src = fetchurl {
        url = "https://github.com/Cockatrice/Cockatrice/archive/${version}-Release.tar.gz";
        sha256 = "1gbcn8vffqdagidlamx670jxymhzaw28r4c6aqg3pq0s6by1l65f";
    };

    buildInputs = [
        cmake qtbase qtmultimedia protobuf qttools
    ];

    meta = {
        repositories.git = git://github.com/Cockatrice/Cockatrice.git;
        description = "A cross-platform virtual tabletop for multiplayer card games";
        license = stdenv.lib.licenses.gpl2;
        maintainers = with stdenv.lib.maintainers; [ spencerjanssen ];
      platforms = with stdenv.lib.platforms; linux;
    };
}
