{ stdenv, fetchFromGitHub, cmake, ffmpeg, popt, help2man }:
    with cmake;
    stdenv.mkDerivation rec {
        name = "nordlicht-${version}";
        version = "0.4.5-git.7ad3f008.4b1751bd";
        license = "GNU GPL v2 or later";
        description = "creates colorful barcodes from video files";
        src = fetchFromGitHub {
            owner  = "nordlicht";
            repo   = "nordlicht";
            rev    = "7ad3f008afe803037b332822028faed64b1751bd";
            sha256 = "14657zfzvq0iki8sn6rq789bgjr7wvvid9y2clfy25bi0a1gvnix";
        };
        buildInputs = [ cmake ffmpeg popt help2man ];
        configurePhase = ''
            mkdir build && cd build && cmake ..
            # why in the galaxy does cmake drop files to
            # /var/lib/empty/local/ and /var/lib/empty/local/usr/lib64/ ?
            # I don't know, but this seems to fix it:
            for f in CMakeCache.txt cmake_install.cmake
            do
                for d in lib{64,32}
                do
                    substituteInPlace "$f" --replace "$d" lib
                done
                for d in /var/empty/local /usr/lib
                do
                    substituteInPlace "$f" --replace "$d" ""
                done
            done
        '';
        installFlags = [ "DESTDIR=$(out)" "CMAKE_INSTAL_PREFIX=$(out)" ];
    }



