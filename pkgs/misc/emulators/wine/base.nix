{ stdenv, lib, pkgArches,
  name, version, src, monos, geckos, platforms,
  pkgconfig, fontforge, makeWrapper, flex, bison,
  pulseaudioSupport,
  buildScript ? null, configureFlags ? ""
}:

assert stdenv.isLinux;
assert stdenv.cc.cc.isGNU or false;

with import ./util.nix { inherit lib; };

stdenv.mkDerivation ((lib.optionalAttrs (! isNull buildScript) {
  builder = buildScript;
}) // rec {
  inherit name src configureFlags;

  nativeBuildInputs = [
    pkgconfig fontforge makeWrapper flex bison
  ];

  buildInputs = toBuildInputs pkgArches (pkgs: (with pkgs; [
    freetype fontconfig mesa mesa_noglu.osmesa libdrm libpng libjpeg openssl gnutls cups ncurses
    alsaLib libxml2 libxslt lcms2 gettext dbus mpg123 openal
  ])
  ++ lib.optional pulseaudioSupport pkgs.libpulseaudio
  ++ (with pkgs.xorg; [
    libXi libXcursor libXinerama libXrandr libXrender libXxf86vm libXcomposite libXext
  ]));

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath " + path) (
      map (x: "${x}/lib") ([ stdenv.cc.cc ] ++ buildInputs)
      # libpulsecommon.so is linked but not found otherwise
      ++ lib.optionals pulseaudioSupport (map (x: "${x}/lib/pulseaudio") (toBuildInputs pkgArches (pkgs: [ pkgs.libpulseaudio ])))
    );

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
