{
  lib,
  fetchurl,
  kaem,
  tinycc,
  gnumake,
  gnupatch,
  coreutils,
}:
let
  pname = "heirloom-devtools";
  version = "070527";

  src = fetchurl {
    url = "mirror://sourceforge/heirloom/heirloom-devtools/heirloom-devtools-${version}.tar.bz2";
    sha256 = "9f233d8b78e4351fe9dd2d50d83958a0e5af36f54e9818521458a08e058691ba";
  };

  # Thanks to the live-bootstrap project!
  # See https://github.com/fosslinux/live-bootstrap/blob/d918b984ad6fe4fc7680f3be060fd82f8c9fddd9/sysa/heirloom-devtools-070527/heirloom-devtools-070527.kaem
  liveBootstrap = "https://github.com/fosslinux/live-bootstrap/raw/d918b984ad6fe4fc7680f3be060fd82f8c9fddd9/sysa/heirloom-devtools-070527";

  patches = [
    # Remove all kinds of wchar support. Mes Libc does not support wchar in any form
    (fetchurl {
      url = "${liveBootstrap}/patches/yacc_remove_wchar.patch";
      sha256 = "0wgiz02bb7xzjy2gnbjp8y31qy6rc4b29v01zi32zh9lw54j68hc";
    })
    # Similarly to yacc, remove wchar. See yacc patch for further information
    (fetchurl {
      url = "${liveBootstrap}/patches/lex_remove_wchar.patch";
      sha256 = "168dfngi51ljjqgd55wbvmffaq61gk48gak50ymnl1br92qkp4zh";
    })
  ];
in
kaem.runCommand "${pname}-${version}"
  {
    inherit pname version;

    nativeBuildInputs = [
      tinycc.compiler
      gnumake
      gnupatch
      coreutils
    ];

    meta = with lib; {
      description = "Portable yacc and lex derived from OpenSolaris";
      homepage = "https://heirloom.sourceforge.net/devtools.html";
      license = with licenses; [
        cddl
        bsdOriginalUC
        caldera
      ];
      teams = [ teams.minimal-bootstrap ];
      platforms = platforms.unix;
    };
  }
  ''
    # Unpack
    unbz2 --file ${src} --output heirloom-devtools.tar
    untar --file heirloom-devtools.tar
    rm heirloom-devtools.tar
    build=''${NIX_BUILD_TOP}/heirloom-devtools-${version}
    cd ''${build}

    # Patch
    ${lib.concatLines (map (f: "patch -Np0 -i ${f}") patches)}

    # Build yacc
    cd yacc
    make -f Makefile.mk \
      CC="tcc -B ${tinycc.libs}/lib" \
      AR="tcc -ar" \
      CFLAGS="-DMAXPATHLEN=4096 -DEILSEQ=84 -DMB_LEN_MAX=100" \
      LDFLAGS="-lgetopt" \
      RANLIB=true \
      LIBDIR=''${out}/lib

    # Install yacc
    install -D yacc ''${out}/bin/yacc
    install -Dm 444 liby.a ''${out}/lib/liby.a
    install -Dm 444 yaccpar ''${out}/lib/yaccpar

    # Make yacc available to lex
    PATH="''${out}/bin:''${PATH}"

    # Build lex
    cd ../lex
    make -f Makefile.mk \
      CC="tcc -B ${tinycc.libs}/lib" \
      AR="tcc -ar" \
      CFLAGS="-DEILSEQ=84 -DMB_LEN_MAX=100" \
      LDFLAGS="-lgetopt" \
      RANLIB=true \
      LIBDIR=''${out}/lib

    # Install lex
    install -D lex ''${out}/bin/lex
    install -Dm 444 ncform ''${out}/lib/lex/ncform
    install -Dm 444 nceucform ''${out}/lib/lex/nceucform
    install -Dm 444 nrform ''${out}/lib/lex/nrform
    install -Dm 444 libl.a ''${out}/lib/libl.a
  ''
