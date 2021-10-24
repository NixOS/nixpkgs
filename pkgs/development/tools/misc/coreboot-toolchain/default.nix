{ bison
, callPackage
, curl
, fetchgit
, flex
, git
, gnat11
, lib
, perl
, stdenvNoCC
, zlib
}:

stdenvNoCC.mkDerivation rec {
  pname = "coreboot-toolchain";
  version = "4.15";

  src = fetchgit {
    url = "https://review.coreboot.org/coreboot";
    rev = version;
    sha256 = "0y137dhfi0zf9nmyq49ksrad69yspbnsmzc4wjkw3hjwvzgi8j27";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ bison curl git perl ];
  buildInputs = [ flex gnat11 zlib ];

  enableParallelBuilding = true;
  dontConfigure = true;
  dontInstall = true;

  postPatch = ''
    mkdir -p util/crossgcc/tarballs

    ${lib.concatMapStringsSep "\n" (
      file: "ln -s ${file.archive} util/crossgcc/tarballs/${file.name}"
      ) (callPackage ./stable.nix { })
    }

    patchShebangs util/genbuild_h/genbuild_h.sh util/crossgcc/buildgcc
  '';

  buildPhase = ''
    make crossgcc-i386 CPUS=$NIX_BUILD_CORES DEST=$out
  '';

  meta = with lib; {
    homepage = "https://www.coreboot.org";
    description = "coreboot toolchain";
    license = with licenses; [ bsd2 bsd3 gpl2 lgpl2Plus gpl3Plus ];
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
