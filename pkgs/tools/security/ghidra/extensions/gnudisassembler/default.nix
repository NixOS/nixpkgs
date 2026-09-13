{
  lib,
  stdenv,
  fetchurl,
  buildGhidraExtension,
  ghidra,
  flex,
  bison,
  gnumake,
  texinfo,
  zlib,
  xcbuild,
}:

let
  # Incorporates source from binutils
  # https://github.com/NationalSecurityAgency/ghidra/blob/7ab9bf6abffb6938d61d072040fc34ad3331332b/GPL/GnuDisassembler/build.gradle#L34-L35
  binutils-version = "2.44";
  binutils-src = fetchurl {
    url = "mirror://gnu/binutils/binutils-${binutils-version}.tar.bz2";
    sha256 = "sha256-9mOQpmH6oRfQD6suec8tydCXtCzClr8/hnfR57RS3Do=";
  };
  gdisPlatform =
    if stdenv.hostPlatform.isDarwin then
      if stdenv.hostPlatform.isAarch64 then "mac_arm_64" else "mac_x86_64"
    else if stdenv.hostPlatform.isAarch64 then
      "linux_arm_64"
    else
      "linux_x86_64";
in
buildGhidraExtension {
  pname = "gnudisassembler";
  version = lib.getVersion ghidra;

  src = "${ghidra}/lib/ghidra/Extensions/Ghidra/${ghidra.distroPrefix}_GnuDisassembler.zip";

  patches = [ ./fix-platform-build.patch ];

  postPatch = ''
    ln -s ${binutils-src} binutils-${binutils-version}.tar.bz2

    substituteInPlace build.gradle \
      --replace-fail 'ext.binutils = "binutils-2.41"' 'ext.binutils = "binutils-${binutils-version}"'

    substituteInPlace buildGdis.gradle \
      --replace-fail "ext.supportedPlatforms = ['mac_x86_64', 'mac_arm_64', 'linux_x86_64', 'linux_arm_64']" \
                     "ext.supportedPlatforms = ['${gdisPlatform}']" \
      --replace-fail '@gdis-platform@' '${gdisPlatform}'
  '';

  # Don't modify ELF stub resources
  dontPatchELF = true;
  dontStrip = true;

  nativeBuildInputs = [
    flex
    bison
    gnumake
    texinfo
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

  meta = {
    description = "Leverage the binutils disassembler capabilities for various processors";
    homepage = "https://ghidra-sre.org/";
    downloadPage = "https://github.com/NationalSecurityAgency/ghidra/tree/master/GPL/GnuDisassembler";
    license = lib.licenses.gpl2Only;
  };
}
