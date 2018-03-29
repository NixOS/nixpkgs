{ stdenv, lib, pkgArches,
  name, version, src, monos, geckos, platforms,
  # flex 2.6.3 causes: undefined reference to `yywrap'
  pkgconfig, fontforge, makeWrapper, flex_2_6_1, bison,
  supportFlags,
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
    pkgconfig fontforge makeWrapper flex_2_6_1 bison
  ];

  buildInputs = toBuildInputs pkgArches (with supportFlags; (pkgs:
  [ pkgs.freetype ]
  ++ lib.optional stdenv.isLinux         pkgs.libcap
  ++ lib.optional pngSupport             pkgs.libpng
  ++ lib.optional jpegSupport            pkgs.libjpeg
  ++ lib.optional cupsSupport            pkgs.cups
  ++ lib.optional colorManagementSupport pkgs.lcms2
  ++ lib.optional gettextSupport         pkgs.gettext
  ++ lib.optional dbusSupport            pkgs.dbus
  ++ lib.optional mpg123Support          pkgs.mpg123
  ++ lib.optional openalSupport          pkgs.openal
  ++ lib.optional cairoSupport           pkgs.cairo
  ++ lib.optional tiffSupport            pkgs.libtiff
  ++ lib.optional odbcSupport            pkgs.unixODBC
  ++ lib.optional netapiSupport          pkgs.samba4
  ++ lib.optional cursesSupport          pkgs.ncurses
  ++ lib.optional vaSupport              pkgs.libva-full
  ++ lib.optional pcapSupport            pkgs.libpcap
  ++ lib.optional v4lSupport             pkgs.libv4l
  ++ lib.optional saneSupport            pkgs.sane-backends
  ++ lib.optional gsmSupport             pkgs.gsm
  ++ lib.optional gphoto2Support         pkgs.libgphoto2
  ++ lib.optional ldapSupport            pkgs.openldap
  ++ lib.optional fontconfigSupport      pkgs.fontconfig
  ++ lib.optional alsaSupport            pkgs.alsaLib
  ++ lib.optional pulseaudioSupport      pkgs.libpulseaudio
  ++ lib.optional xineramaSupport        pkgs.xorg.libXinerama
  ++ lib.optional udevSupport            pkgs.udev
  ++ lib.optionals gstreamerSupport      (with pkgs.gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ])
  ++ lib.optionals gtkSupport    [ pkgs.gtk3 pkgs.glib ]
  ++ lib.optionals openclSupport [ pkgs.opencl-headers pkgs.ocl-icd ]
  ++ lib.optionals xmlSupport    [ pkgs.libxml2 pkgs.libxslt ]
  ++ lib.optionals tlsSupport    [ pkgs.openssl pkgs.gnutls ]
  ++ lib.optionals openglSupport [ pkgs.libGLU_combined pkgs.libGL.osmesa pkgs.libdrm ]
  ++ (with pkgs.xorg; [
    libX11  libXi libXcursor libXrandr libXrender libXxf86vm libXcomposite libXext
  ])));

  # Wine locates a lot of libraries dynamically through dlopen().  Add
  # them to the RPATH so that the user doesn't have to set them in
  # LD_LIBRARY_PATH.
  NIX_LDFLAGS = map (path: "-rpath " + path) (
      map (x: "${lib.getLib x}/lib") ([ stdenv.cc.cc ] ++ buildInputs)
      # libpulsecommon.so is linked but not found otherwise
      ++ lib.optionals supportFlags.pulseaudioSupport (map (x: "${lib.getLib x}/lib/pulseaudio")
          (toBuildInputs pkgArches (pkgs: [ pkgs.libpulseaudio ])))
    );

  # Don't shrink the ELF RPATHs in order to keep the extra RPATH
  # elements specified above.
  dontPatchELF = true;

  # Disable stripping to avoid breaking placeholder DLLs/EXEs.
  # Symptoms of broken placeholders are: when the wineprefix is created
  # drive_c/windows/system32 will only contain a few files instead of
  # hundreds, there will be an error about winemenubuilder and MountMgr
  # on startup of Wine, and the Drives tab in winecfg will show an error.
  dontStrip = true;

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
  '' + lib.optionalString supportFlags.gstreamerSupport ''
    for i in wine ; do
      if [ -e "$out/bin/$i" ]; then
        wrapProgram "$out/bin/$i" \
          --argv0 "" \
          --prefix GST_PLUGIN_SYSTEM_PATH_1_0 ":" "$GST_PLUGIN_SYSTEM_PATH_1_0"
      fi
    done
  '';
  
  enableParallelBuilding = true;

  # https://bugs.winehq.org/show_bug.cgi?id=43530
  # https://github.com/NixOS/nixpkgs/issues/31989
  hardeningDisable = [ "bindnow" ];

  passthru = { inherit pkgArches; };
  meta = {
    inherit version platforms;
    homepage = http://www.winehq.org/;
    license = "LGPL";
    description = "An Open Source implementation of the Windows API on top of X, OpenGL, and Unix";
    maintainers = with stdenv.lib.maintainers; [ avnik raskin bendlas ];
  };
})
