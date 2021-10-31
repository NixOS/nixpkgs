{ callPackage, fetchgit, lib, stdenvNoCC
, bison, curl, git, perl
, flex, gnat11, zlib
}:

stdenvNoCC.mkDerivation rec {
  pname = "coreboot-toolchain";
  version = "4.14";

  src = fetchgit {
    url = "https://review.coreboot.org/coreboot";
    rev = version;
    sha256 = "00xr74yc0kj9rrqa1a8b7bih865qlp9i4zs67ysavkfrjrwwssxm";
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
