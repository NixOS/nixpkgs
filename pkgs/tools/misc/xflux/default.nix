{stdenv, fetchurl, libXxf86vm, libXext, libX11, libXrandr, gcc}:
stdenv.mkDerivation {
  name = "xflux-2013-09-01";
  src = fetchurl {
    url = "https://justgetflux.com/linux/xflux64.tgz";
    sha256 = "cc50158fabaeee58c331f006cc1c08fd2940a126e99d37b76c8e878ef20c2021";
  };

  libPath = stdenv.lib.makeLibraryPath [
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
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.paholg ];
  };
}
