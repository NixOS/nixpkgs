{ stdenv, fetchFromGitHub, installShellFiles, gnustep, bzip2, zlib, icu, openssl, wavpack }:

stdenv.mkDerivation rec {
  pname = "unar";
  version = "1.10.7";

  src = fetchFromGitHub {
    owner = "MacPaw";
    # the unar repo contains a shallow clone of both XADMaster and universal-detector
    repo = "unar";
    rev = "v${version}";
    sha256 = "0p846q1l66k3rnd512sncp26zpv411b8ahi145sghfcsz9w8abc4";
  };

  postPatch = ''
    for f in Makefile.linux ../UniversalDetector/Makefile.linux ; do
      substituteInPlace $f \
        --replace "= gcc" "=cc" \
        --replace "= g++" "=c++" \
        --replace "-DGNU_RUNTIME=1" "" \
        --replace "-fgnu-runtime" "-fobjc-nonfragile-abi"
    done

    # we need to build inside this directory as well, so we have to make it writeable
    chmod +w ../UniversalDetector -R
  '';

  buildInputs = [ gnustep.base bzip2 icu openssl wavpack zlib ];

  nativeBuildInputs = [ gnustep.make installShellFiles ];

  enableParallelBuilding = true;

  dontConfigure = true;

  makefile = "Makefile.linux";

  sourceRoot = "./source/XADMaster";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin lsar unar
    for f in lsar unar; do
      installManPage ./Extra/$f.?
      installShellCompletion --bash --name $f ./Extra/$f.bash_completion
    done

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://theunarchiver.com";
    description = "An archive unpacker program";
    longDescription = ''
      The Unarchiver is an archive unpacker program with support for the popular \
      zip, RAR, 7z, tar, gzip, bzip2, LZMA, XZ, CAB, MSI, NSIS, EXE, ISO, BIN, \
      and split file formats, as well as the old Stuffit, Stuffit X, DiskDouble, \
      Compact Pro, Packit, cpio, compress (.Z), ARJ, ARC, PAK, ACE, ZOO, LZH, \
      ADF, DMS, LZX, PowerPacker, LBR, Squeeze, Crunch, and other old formats.
    '';
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
