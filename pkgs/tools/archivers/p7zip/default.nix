{
  lib,
  stdenv,
  fetchFromGitHub,
  enableUnfree ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "p7zip";
  version = "17.05";

  src = fetchFromGitHub {
    owner = "p7zip-project";
    repo = "p7zip";
    rev = "v${finalAttrs.version}";
    sha256 =
      {
        free = "sha256-5r7M9BVcAryZNTkqJ/BfHnSSWov1PwoZhUnLBwEbJoA=";
        unfree = "sha256-z3qXgv/TkNRbb85Ew1OcJNxoyssfzHShc0b0/4NZOb0=";
      }
      .${if enableUnfree then "unfree" else "free"};
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
  postPatch =
    ''
      sed -i '/CC=\/usr/d' makefile.macosx_llvm_64bits
      # Avoid writing timestamps into compressed manpages
      # to maintain determinism.
      substituteInPlace install.sh --replace 'gzip' 'gzip -n'
      chmod +x install.sh

      # I think this is a typo and should be CXX? Either way let's kill it
      sed -i '/XX=\/usr/d' makefile.macosx_llvm_64bits
    ''
    + lib.optionalString (stdenv.buildPlatform != stdenv.hostPlatform) ''
      substituteInPlace makefile.machine \
        --replace 'CC=gcc'  'CC=${stdenv.cc.targetPrefix}gcc' \
        --replace 'CXX=g++' 'CXX=${stdenv.cc.targetPrefix}g++'
    '';

  preConfigure =
    ''
      buildFlags=all3
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp makefile.macosx_llvm_64bits makefile.machine
    '';

  enableParallelBuilding = true;
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=c++11-narrowing";

  makeFlags = [
    "DEST_BIN=${placeholder "out"}/bin"
    "DEST_SHARE=${placeholder "lib"}/lib/p7zip"
    "DEST_MAN=${placeholder "man"}/share/man"
    "DEST_SHARE_DOC=${placeholder "doc"}/share/doc/p7zip"
  ];

  outputs = [
    "out"
    "lib"
    "doc"
    "man"
  ];

  setupHook = ./setup-hook.sh;
  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://github.com/p7zip-project/p7zip";
    description = "New p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)";
    license =
      with licenses;
      # p7zip code is largely lgpl2Plus
      # CPP/7zip/Compress/LzfseDecoder.cpp is bsd3
      [
        lgpl2Plus # and
        bsd3
      ]
      ++
        # and CPP/7zip/Compress/Rar* are unfree with the unRAR license restriction
        # the unRAR compression code is disabled by default
        lib.optionals enableUnfree [ unfree ];
    maintainers = with maintainers; [
      raskin
      jk
    ];
    platforms = platforms.unix;
    mainProgram = "7z";
  };
})
