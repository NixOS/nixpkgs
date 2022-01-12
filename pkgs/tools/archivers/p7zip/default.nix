{ stdenv, fetchFromGitHub, fetchpatch, lib, enableUnfree ? false }:

stdenv.mkDerivation rec {
  pname = "p7zip";
  version = "17.04";

  src = fetchFromGitHub {
    owner  = "jinfeihan57";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-19F4hPV0nKVuFZNbOcXrcA1uW6Y3HQolaHVIYXGmh18=";
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
  '' + lib.optionalString (!enableUnfree) ''
    # Remove non-free RAR source code
    # (see DOC/License.txt, https://fedoraproject.org/wiki/Licensing:Unrar)
    rm -r CPP/7zip/Compress/Rar*
    find . -name makefile'*' -exec sed -i '/Rar/d' {} +
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

  meta = {
    homepage = "https://github.com/jinfeihan57/p7zip";
    description = "A new p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.raskin ];
    mainProgram = "7z";
    # RAR code is under non-free UnRAR license, but we remove it
    license = if enableUnfree then lib.licenses.unfree else lib.licenses.lgpl2Plus;
  };
}
