{ stdenv, lib, pkgArches,
  name, version, src, monos, geckos, platforms,
  buildScript ? null, configureFlags ? ""
}:

assert stdenv.isLinux;
assert stdenv.cc.cc.isGNU or false;

stdenv.mkDerivation ((lib.optionalAttrs (! isNull buildScript) {
  builder = buildScript;
}) // {
  inherit name src configureFlags;

  buildInputs = lib.concatLists (map (pkgs: (with pkgs; [
    pkgconfig alsaLib ncurses libpng libjpeg lcms2 fontforge libxml2 libxslt
    openssl gnutls cups makeWrapper flex bison mesa mesa_noglu.osmesa
  ]) ++ (with pkgs.xlibs; [
    xlibs libXi libXcursor libXinerama libXrandr libXrender libXxf86vm libXcomposite
  ])) pkgArches);

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath ${path}/lib") ([
    stdenv.cc.cc
  ] ++ (lib.concatLists (map (pkgs:
        (with pkgs; [
    freetype fontconfig mesa mesa_noglu.osmesa libdrm
    libpng libjpeg openssl gnutls cups ncurses
  ]) ++ (with pkgs.xlibs; [
    libXinerama libXrender libXrandr libXcursor libXcomposite
  ])) pkgArches)));

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  ## FIXME
  # Add capability to ignore known failing tests
  # and enable doCheck
  doCheck = false;
  
  postInstall = let
    links = prefix: pkg: "ln -s ${pkg} $out/${prefix}/${pkg.name}";
  in ''
    mkdir -p $out/share/wine/gecko $out/share/wine/mono/
    ${lib.strings.concatStringsSep "\n"
          ((map (links "share/wine/gecko") geckos)
        ++ (map (links "share/wine/mono")  monos))}
  '';
  
  enableParallelBuilding = true;

  meta = {
    inherit version platforms;
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = [stdenv.lib.maintainers.raskin];
  };
})
