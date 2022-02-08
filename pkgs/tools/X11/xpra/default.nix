{ lib
, fetchurl
, substituteAll, python3, pkg-config, runCommand, writeText
, xorg, gtk3, glib, pango, cairo, gdk-pixbuf, atk, pandoc
, wrapGAppsHook, xorgserver, getopt, xauth, util-linux, which
, ffmpeg, x264, libvpx, libwebp, x265, librsvg
, libfakeXinerama
, gst_all_1, pulseaudio, gobject-introspection
, withNvenc ? false, cudatoolkit, nv-codec-headers-10, nvidia_x11 ? null
, pam }:

with lib;

let
  inherit (python3.pkgs) cython buildPythonApplication;

  xf86videodummy = xorg.xf86videodummy.overrideDerivation (p: {
    patches = [
      # patch provided by Xpra upstream
      ./0002-Constant-DPI.patch
      # https://github.com/Xpra-org/xpra/issues/349
      ./0003-fix-pointer-limits.patch
      # patch provided by Xpra upstream
      ./0005-support-for-30-bit-depth-in-dummy-driver.patch
    ];
  });

  xorgModulePaths = writeText "module-paths" ''
    Section "Files"
      ModulePath "${xorgserver}/lib/xorg/modules"
      ModulePath "${xorgserver}/lib/xorg/modules/extensions"
      ModulePath "${xorgserver}/lib/xorg/modules/drivers"
      ModulePath "${xf86videodummy}/lib/xorg/modules/drivers"
    EndSection
  '';

  nvencHeaders = runCommand "nvenc-headers" {
    inherit nvidia_x11;
  } ''
    mkdir -p $out/include $out/lib/pkgconfig
    cp ${nv-codec-headers-10}/include/ffnvcodec/nvEncodeAPI.h $out/include
    substituteAll ${./nvenc.pc} $out/lib/pkgconfig/nvenc.pc
  '';
in buildPythonApplication rec {
  pname = "xpra";
  version = "4.3.1";

  src = fetchurl {
    url = "https://xpra.org/src/${pname}-${version}.tar.xz";
    hash = "sha256-v0Abn0oYcl1I4H9GLN1pV9hk9tTE+Wlv2gPTtEE6t6k=";
  };

  patches = [
    (substituteAll {  # correct hardcoded paths
      src = ./fix-paths.patch;
      inherit libfakeXinerama;
    })
    ./fix-41106.patch  # https://github.com/NixOS/nixpkgs/issues/41106
  ];

  INCLUDE_DIRS = "${pam}/include";

  nativeBuildInputs = [ pkg-config wrapGAppsHook pandoc ]
    ++ lib.optional withNvenc cudatoolkit;
  buildInputs = with xorg; [
    libX11 xorgproto libXrender libXi libXres
    libXtst libXfixes libXcomposite libXdamage
    libXrandr libxkbfile
    ] ++ [
    cython
    librsvg

    pango cairo gdk-pixbuf atk.out gtk3 glib

    ffmpeg libvpx x264 libwebp x265

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    pam
    gobject-introspection
  ] ++ lib.optional withNvenc nvencHeaders;
  propagatedBuildInputs = with python3.pkgs; [
    pillow rencode pycrypto cryptography pycups lz4 dbus-python
    netifaces numpy pygobject3 pycairo gst-python pam
    pyopengl paramiko opencv4 python-uinput pyxdg
    ipaddress idna pyinotify
  ] ++ lib.optionals withNvenc (with python3.pkgs; [pynvml pycuda]);

    # error: 'import_cairo' defined but not used
  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  setupPyBuildFlags = [
    "--with-Xdummy"
    "--without-Xdummy_wrapper"
    "--without-strict"
    "--with-gtk3"
    # Override these, setup.py checks for headers in /usr/* paths
    "--with-pam"
    "--with-vsock"
  ] ++ lib.optional withNvenc "--with-nvenc";

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --set XPRA_INSTALL_PREFIX "$out"
      --set XPRA_COMMAND "$out/bin/xpra"
      --set XPRA_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb"
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib
      --prefix PATH : ${lib.makeBinPath [ getopt xorgserver xauth which util-linux pulseaudio ]}
  '' + lib.optionalString withNvenc ''
      --prefix LD_LIBRARY_PATH : ${nvidia_x11}/lib
  '' + ''
    )
  '';

  # append module paths to xorg.conf
  postInstall = ''
    cat ${xorgModulePaths} >> $out/etc/xpra/xorg.conf
  '';

  doCheck = false;

  enableParallelBuilding = true;

  passthru = {
    inherit xf86videodummy;
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://xpra.org/";
    downloadPage = "https://xpra.org/src/";
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel offline numinit mvnetbiz ];
  };
}
