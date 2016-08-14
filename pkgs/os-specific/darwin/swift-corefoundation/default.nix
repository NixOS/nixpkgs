{ stdenv, fetchFromGitHub, python, ninja, libpthread, libxml2 }:

stdenv.mkDerivation {
  name = "swift-corefoundation";

  src = fetchFromGitHub {
    owner  = "apple";
    repo   = "swift-corelibs-foundation";
    rev    = "87d1a97d6af07fec568765c47daddff0aaa0d59c";
    sha256 = "05cmqwzqqxb489g9hq7hhj2yva12pi488iblbpnvyk1y4nx077cw";
  };

  buildInputs = [ ninja python libxml2 ];

  patchPhase = ''
    HACK=$PWD/hack
    mkdir -p $HACK/CoreFoundation
    cp CoreFoundation/Base.subproj/CFAsmMacros.h $HACK/CoreFoundation

    substituteInPlace CoreFoundation/build.py \
      --replace "','" "'," \
      --replace '-I''${SYSROOT}/usr/include/libxml2' '-I${libxml2.dev}/include/libxml2' \
      --replace 'cf.ASFLAGS = " ".join([' "cf.ASFLAGS = ' '.join([ '-I$HACK', " \
  '';

  configureFlags = "--sysroot unused";

  buildPhase = ''
    cd CoreFoundation
    ../configure --sysroot foo
    ninja
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp ../Build/CoreFoundation/libCoreFoundation.a $out/lib
  '';
}
