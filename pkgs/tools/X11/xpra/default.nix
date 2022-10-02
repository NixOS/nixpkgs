{ lib
, fetchurl
, substituteAll
, pkg-config
, runCommand
, writeText
, wrapGAppsHook
, withNvenc ? false
, atk
, cairo
, cudatoolkit
, ffmpeg
, gdk-pixbuf
, getopt
, glib
, gobject-introspection
, gst_all_1
, gtk3
, libfakeXinerama
, librsvg
, libvpx
, libwebp
, nv-codec-headers-10
, nvidia_x11 ? null
, pam
, pandoc
, pango
, pulseaudio
, python3
, util-linux
, which
, x264
, x265
, xauth
, xorg
, xorgserver
}:

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
  version = "4.3.3";

  src = fetchurl {
    url = "https://xpra.org/src/${pname}-${version}.tar.xz";
    hash = "sha256-J6zzkho0A1faCVzS/0wDlbgLtJmyPrnBkEcR7kDld7A=";
  };

  patches = [
    (substituteAll {  # correct hardcoded paths
      src = ./fix-paths.patch;
      inherit libfakeXinerama;
    })
    ./fix-41106.patch  # https://github.com/NixOS/nixpkgs/issues/41106
    ./fix-122159.patch # https://github.com/NixOS/nixpkgs/issues/122159
  ];

  INCLUDE_DIRS = "${pam}/include";

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook
    pandoc
  ] ++ lib.optional withNvenc cudatoolkit;

  buildInputs = with xorg; [
    libX11
    libXcomposite
    libXdamage
    libXfixes
    libXi
    libxkbfile
    libXrandr
    libXrender
    libXres
    libXtst
    xorgproto
  ] ++ (with gst_all_1; [
    gst-libav
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]) ++ [
    atk.out
    cairo
    cython
    ffmpeg
    gdk-pixbuf
    glib
    gtk3
    librsvg
    libvpx
    libwebp
    pam
    pango
    x264
    x265
  ] ++ lib.optional withNvenc nvencHeaders;

  propagatedBuildInputs = with python3.pkgs; ([
    cryptography
    dbus-python
    gst-python
    idna
    lz4
    netifaces
    numpy
    opencv4
    pam
    paramiko
    pillow
    pycairo
    pycrypto
    pycups
    pygobject3
    pyinotify
    pyopengl
    python-uinput
    pyxdg
    rencode
  ] ++ lib.optionals withNvenc [
    pycuda
    pynvml
  ]);

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
      --set XORG_CONFIG_PREFIX ""
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
    maintainers = with maintainers; [ offline numinit mvnetbiz ];
  };
}
