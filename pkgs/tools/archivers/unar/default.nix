{ stdenv, fetchurl, gnustep, unzip, bzip2, zlib, icu, openssl }:

let
  pname = "unar";

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.10.1";

  src = fetchurl {
    url = "http://unarchiver.c3.cx/downloads/${pname}${version}_src.zip";
    sha256 = "0aq9zlar5vzr5qxphws8dm7ax60bsfsw77f4ciwa5dq5lla715j0";
  };

  buildInputs = [ gnustep.base bzip2 icu openssl zlib ];

  nativeBuildInputs = [ gnustep.make unzip ];

  enableParallelBuilding = true;

  postPatch = ''
    for f in Makefile.linux ../UniversalDetector/Makefile.linux ; do
      substituteInPlace $f \
        --replace "CC = gcc"     "CC=cc" \
        --replace "CXX = g++"    "CXX=c++" \
        --replace "OBJCC = gcc"  "OBJCC=cc" \
        --replace "OBJCXX = g++" "OBJCXX=c++"
    done
  '';

  makefile = "Makefile.linux";

  sourceRoot = "./The Unarchiver/XADMaster";

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin lsar unar
    install -Dm644 -t $out/share/man/man1 ../Extra/{lsar,unar}.1

    mkdir -p $out/etc/bash_completion.d
    cp ../Extra/lsar.bash_completion $out/etc/bash_completion.d/lsar
    cp ../Extra/unar.bash_completion $out/etc/bash_completion.d/unar

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = http://unarchiver.c3.cx/unarchiver;
    description = "An archive unpacker program";
    longDescription = ''
      The Unarchiver is an archive unpacker program with support for the popular \
      zip, RAR, 7z, tar, gzip, bzip2, LZMA, XZ, CAB, MSI, NSIS, EXE, ISO, BIN, \
      and split file formats, as well as the old Stuffit, Stuffit X, DiskDouble, \
      Compact Pro, Packit, cpio, compress (.Z), ARJ, ARC, PAK, ACE, ZOO, LZH, \
      ADF, DMS, LZX, PowerPacker, LBR, Squeeze, Crunch, and other old formats.
    '';
    license = with licenses; [ lgpl21Plus ];
    platforms = with platforms; linux;
  };
}
