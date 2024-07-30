{lib, stdenv, fetchurl, libXxf86vm, libXext, libX11, libXrandr, gcc}:
stdenv.mkDerivation {
  pname = "xflux";
  version = "unstable-2013-09-01";
  src = fetchurl {
    url = "https://justgetflux.com/linux/xflux64.tgz";
    sha256 = "cc50158fabaeee58c331f006cc1c08fd2940a126e99d37b76c8e878ef20c2021";
  };

  libPath = lib.makeLibraryPath [
    gcc.cc
    libXxf86vm
    libXext
    libX11
    libXrandr
  ];

  unpackPhase = ''
    unpackFile $src;
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    cp  xflux "$out/bin"
  '';
  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath "$libPath" "$out/bin/xflux"
  '';
  meta = {
    description = "Adjusts your screen to emit warmer light at night";
    longDescription = ''
      xflux changes the color temperature of your screen to be much warmer
      when the sun sets, and then changes it back its colder temperature
      when the sun rises.
    '';
    homepage = "https://justgetflux.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.paholg ];
    mainProgram = "xflux";
  };
}
