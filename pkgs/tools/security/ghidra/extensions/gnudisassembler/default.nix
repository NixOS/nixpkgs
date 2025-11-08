{
  lib,
  stdenv,
  fetchurl,
  buildGhidraExtension,
  ghidra,
  flex,
  bison,
  texinfo,
  perl,
  zlib,
  xcbuild,
}:

let
  # Incorporates source from binutils
  # https://github.com/NationalSecurityAgency/ghidra/blob/7ab9bf6abffb6938d61d072040fc34ad3331332b/GPL/GnuDisassembler/build.gradle#L34-L35
  binutils-version = "2.41";
  binutils-src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${binutils-version}.tar.bz2";
    sha256 = "sha256-pMS+wFL3uDcAJOYDieGUN38/SLVmGEGOpRBn9nqqsws=";
  };
in
buildGhidraExtension {
  pname = "gnudisassembler";
  version = lib.getVersion ghidra;

  src = "${ghidra}/lib/ghidra/Extensions/Ghidra/${ghidra.distroPrefix}_GnuDisassembler.zip";

  postPatch = ''
    ln -s ${binutils-src} binutils-${binutils-version}.tar.bz2
  '';

  # Don't modify ELF stub resources
  dontPatchELF = true;
  dontStrip = true;

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    flex
    bison
    texinfo
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  buildInputs = [ zlib ];
  gradleBuildTask = "assemble";

  installPhase = ''
    runHook preInstall

    EXTENSIONS_ROOT=$out/lib/ghidra/Ghidra/Extensions
    mkdir -p $EXTENSIONS_ROOT
    unzip -d $EXTENSIONS_ROOT $src

    mkdir -p $EXTENSIONS_ROOT/GnuDisassembler/build
    cp -r build/os $EXTENSIONS_ROOT/GnuDisassembler/build/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Leverage the binutils disassembler capabilities for various processors";
    homepage = "https://ghidra-sre.org/";
    downloadPage = "https://github.com/NationalSecurityAgency/ghidra/tree/master/GPL/GnuDisassembler";
    license = licenses.gpl2Only;
  };
}
