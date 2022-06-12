{ stdenv, fetchFromGitHub, fetchpatch, lib, enableUnfree ? false }:

stdenv.mkDerivation rec {
  pname = "p7zip";
  version = "17.04";

  src = fetchFromGitHub {
    owner  = "jinfeihan57";
    repo   = pname;
    rev    = "v${version}";
    sha256 = {
      free = "sha256-DrBuf2VPdcprHI6pMSmL7psm2ofOrUf0Oj0qwMjXzkk=";
      unfree = "sha256-19F4hPV0nKVuFZNbOcXrcA1uW6Y3HQolaHVIYXGmh18=";
    }.${if enableUnfree then "unfree" else "free"};
    # remove the unRAR related code from the src drv
    # > the license requires that you agree to these use restrictions,
    # > or you must remove the software (source and binary) from your hard disks
    # https://fedoraproject.org/wiki/Licensing:Unrar
    postFetch = lib.optionalString (!enableUnfree) ''
      rm -r $out/CPP/7zip/Compress/Rar*
      find $out -name makefile'*' -exec sed -i '/Rar/d' {} +
    '';
  };

  # Default makefile is full of impurities on Darwin. The patch doesn't hurt Linux so I'm leaving it unconditional
  postPatch = ''
    sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits
    # Avoid writing timestamps into compressed manpages
    # to maintain determinism.
    substituteInPlace install.sh --replace 'gzip' 'gzip -n'
    chmod +x install.sh

    # I think this is a typo and should be CXX? Either way let's kill it
    sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
  '' + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
    substituteInPlace makefile.machine \
      --replace 'CC=gcc'  'CC=${stdenv.cc.targetPrefix}gcc' \
      --replace 'CXX=g++' 'CXX=${stdenv.cc.targetPrefix}g++'
  '';

  makeFlags = [ "DEST_HOME=${placeholder "out"}" ];

  preConfigure = ''
    buildFlags=all3
  '' + lib.optionalString stdenv.isDarwin ''
    cp makefile.macosx_llvm_64bits makefile.machine
  '';

  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/jinfeihan57/p7zip";
    description = "A new p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)";
    license = with licenses;
      # p7zip code is largely lgpl2Plus
      # CPP/7zip/Compress/LzfseDecoder.cpp is bsd3
      [ lgpl2Plus /* and */ bsd3 ] ++
      # and CPP/7zip/Compress/Rar* are unfree with the unRAR license restriction
      # the unRAR compression code is disabled by default
      lib.optionals enableUnfree [ unfree ];
    maintainers = with maintainers; [ raskin jk ];
    platforms = platforms.unix;
    mainProgram = "7z";
  };
}
