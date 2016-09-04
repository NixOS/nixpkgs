{ stdenv, fetchurl, cmake, qtbase, qtmultimedia, protobuf, qttools
}:

stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "cockatrice";
    version = "2015-09-24";

    src = fetchurl {
        url = "https://github.com/Cockatrice/Cockatrice/archive/${version}-Release.tar.gz";
        sha256 = "068f93k3bg4cmdm0iyh2vfmk51nnzf3d6g6cvlm5q8dz1zk5nwzf";
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
