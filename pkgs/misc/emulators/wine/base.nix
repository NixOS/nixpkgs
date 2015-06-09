{ stdenv, lib, pkgArches,
  name, version, src, monos, geckos, platforms,
  buildScript ? null, configureFlags ? ""
}:

assert stdenv.isLinux;
assert stdenv.cc.cc.isGNU or false;

with import ./util.nix { inherit lib; };

stdenv.mkDerivation ((lib.optionalAttrs (! isNull buildScript) {
  builder = buildScript;
}) // rec {
  inherit name src configureFlags;

  buildInputs = toBuildInputs pkgArches (pkgs: with pkgs; [
    pkgconfig alsaLib lcms2 fontforge libxml2 libxslt makeWrapper flex bison
  ]);

  nativeBuildInputs = toBuildInputs pkgArches (pkgs: (with pkgs; [
    freetype fontconfig mesa mesa_noglu.osmesa libdrm libpng libjpeg openssl gnutls cups ncurses
  ]) ++ (with pkgs.xlibs; [
    xlibs libXi libXcursor libXinerama libXrandr libXrender libXxf86vm libXcomposite
  ]));

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map
    (path: "-rpath ${path}/lib")
    ([ stdenv.cc.cc ] ++ nativeBuildInputs);

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

  passthru = { inherit pkgArches; };
  meta = {
    inherit version platforms;
    homepage = "http://www.winehq.org/";
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = [stdenv.lib.maintainers.raskin];
  };
})
