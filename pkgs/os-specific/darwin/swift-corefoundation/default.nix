{ stdenv, fetchFromGitHub, python, ninja, libxml2 }:

stdenv.mkDerivation {
  name = "swift-corefoundation";

  src = fetchFromGitHub {
    owner  = "apple";
    repo   = "swift-corelibs-foundation";
    rev    = "dce4233f583ec15190b240d6116396bf9641cd57";
    sha256 = "0i2ldvy14x05k2vgl5z0g5l2i5llifdfbij5zwfdwb8jmmq215qr";
  };

  buildInputs = [ ninja python libxml2 ];

  patchPhase = ''
    substituteInPlace CoreFoundation/build.py \
      --replace '-I''${SYSROOT}/usr/include/libxml2' '-I${libxml2.dev}/include/libxml2' \
  '';

  configurePhase = ":";

  buildPhase = ''
    cd CoreFoundation
    ../configure --sysroot unused
    ninja
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp ../Build/CoreFoundation/libCoreFoundation.a $out/lib
  '';
}
