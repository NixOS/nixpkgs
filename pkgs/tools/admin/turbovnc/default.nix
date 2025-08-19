{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,

  # Dependencies
  bzip2,
  cmake,
  dri-pkgconfig-stub,
  freetype,
  libGL,
  libgbm,
  libjpeg_turbo,
  makeWrapper,
  mesa-gl-headers, # for built-in 3D software rendering using swrast
  openjdk, # for the client with Java GUI
  openjdk_headless, # for the server
  openssh,
  openssl,
  pam,
  perl,
  pkg-config,
  python3,
  which,
  xkbcomp,
  xkeyboard_config,
  xorg,
  xterm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "turbovnc";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "TurboVNC";
    repo = "turbovnc";
    rev = finalAttrs.version;
    hash = "sha256-CMJdUG4Dd7pbtr/KXq0hV+zR5i+L/y610O+SWJTR/zQ=";
  };

  # Notes:
  # * SSH support does not require `openssh` on PATH, because turbovnc
  #   uses a built-in SSH client ("JSch fork"), as commented on e.g.:
  #   https://github.com/TurboVNC/turbovnc/releases/tag/3.2beta1
  #
  # TODO:
  # * Build outputs that are unclear:
  #   * `-- FONT_ENCODINGS_DIRECTORY = /var/empty/share/X11/fonts/encodings`
  #     Maybe relevant what the tigervnc and tightvnc derivations
  #     do with their `fontDirectories`?
  #   * `XORG_REGISTRY_PATH = /var/empty/lib64/xorg`
  #   * The thing about xorg `protocol.txt`
  # * Add `enableClient ? true` flag that disables the client GUI
  #   so that the server can be built without openjdk dependency.
  # * Perhaps allow to build the client on non-Linux platforms.

  nativeBuildInputs = [
    cmake
    makeWrapper
    openjdk_headless
    pkg-config
    python3
  ];

  buildInputs = [
    bzip2
    dri-pkgconfig-stub
    freetype
    libGL # for -DTVNC_SYSTEMX11=1
    libgbm
    libjpeg_turbo
    openssl
    pam
    perl
  ]
  ++ (with xorg; [
    libfontenc # for -DTVNC_SYSTEMX11=1
    libSM
    libX11
    libXdamage # for -DTVNC_SYSTEMX11=1
    libXdmcp # for -DTVNC_SYSTEMX11=1
    libXext
    libXfont2 # for -DTVNC_SYSTEMX11=1
    libxkbfile # for -DTVNC_SYSTEMX11=1
    libxshmfence
    libXi
    mesa-gl-headers # for -DTVNC_SYSTEMX11=1
    pixman # for -DTVNC_SYSTEMX11=1
    xorgproto
    xtrans # for -DTVNC_SYSTEMX11=1
  ]);

  postPatch = ''
    substituteInPlace unix/Xvnc/CMakeLists.txt --replace 'string(REGEX REPLACE "X11" "Xfont2" X11_Xfont2_LIB' 'set(X11_Xfont2_LIB ${xorg.libXfont2}/lib/libXfont2.so)  #'
    substituteInPlace unix/Xvnc/CMakeLists.txt --replace 'string(REGEX REPLACE "X11" "fontenc" X11_Fontenc_LIB' 'set(X11_Fontenc_LIB ${xorg.libfontenc}/lib/libfontenc.so)  #'
    substituteInPlace unix/Xvnc/CMakeLists.txt --replace 'string(REGEX REPLACE "X11" "pixman-1" X11_Pixman_LIB' 'set(X11_Pixman_LIB ${xorg.pixman}/lib/libpixman-1.so)  #'
  '';

  cmakeFlags = [
    # For the 3D software rendering built into TurboVNC, pass the path
    # to the swrast dri driver in Mesa.
    # Can also be given at runtime to its `Xvnc` as:
    #   -dridir /nix/store/...-mesa-20.1.10-drivers/lib/dri/
    "-DXORG_DRI_DRIVER_PATH=${libGL.driverLink}/lib/dri"
    # The build system doesn't find these files automatically.
    "-DXKB_BASE_DIRECTORY=${xkeyboard_config}/share/X11/xkb"
    "-DXKB_BIN_DIRECTORY=${xkbcomp}/bin"
    # use system libs
    # TurboVNC >= 3.1.4 no longer needs overrides to use system libraries
    # instead of bundling them, see
    # https://github.com/TurboVNC/turbovnc/releases/tag/3.2beta1:
    # >  The TVNC_SYSTEMLIBS and TVNC_SYSTEMX11 CMake variables have been removed,
    # > and the build system now behaves as if those variables are always on.
    # > A new CMake variable (TVNC_ZLIBNG) can be used on x86 platforms
    # > to disable the in-tree SIMD-accelerated zlib-ng implementation
    # > and build against the system-supplied zlib implementation.
    #
    # We'd like to build against nixpkgs's `zlib-ng`, but if we pass
    # `-DTVNC_ZLIBNG=0`, the above logic seems to imply that it looks
    # for normal zlib as well, and the `./configure` output prints
    #     -- zlib-ng disabled (TVNC_ZLIBNG = 0)
    #     -- Found ZLIB: /nix/store/<...>/lib/libz.so (found version "1.3.1")
    # so that seems to use normal `zlib`, even though it's not declared
    # as a dependency here (probably it's part of `stdenv`).
    # So for now, we use TruboVNC's in-tree `zlib-ng`.
    #     "-DTVNC_ZLIBNG=0" # not given currently as explained above
  ];

  postInstall = ''
    # turbovnc dlopen()s libssl.so depending on the requested encryption.
    wrapProgram $out/bin/Xvnc \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]}

    # `twm` is the default window manager that `vncserver` tries to start,
    # and it has minimal dependencies (no non-Xorg).
    # (This default is written by `vncserver` to `~/.vnc/xstartup.turbovnc`,
    # see https://github.com/TurboVNC/turbovnc/blob/ffdb57d9/unix/vncserver.in#L201.)
    # It checks for it using `which twm`.
    # vncserver needs also needs `xauth` and we add in `xterm` for convenience
    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${
        lib.makeBinPath [
          which
          xorg.twm
          xorg.xauth
          xterm
        ]
      }

    # Patch /usr/bin/perl
    patchShebangs $out/bin/vncserver

    # The viewer is in Java and requires `JAVA_HOME` (which is a single
    # path, cannot be multiple separated paths).
    # For SSH support, `ssh` is required on `PATH`.
    wrapProgram $out/bin/vncviewer \
      --set JAVA_HOME "${lib.makeLibraryPath [ openjdk ]}/openjdk" \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  passthru.tests.turbovnc-headless-server = nixosTests.turbovnc-headless-server;

  meta = {
    homepage = "https://turbovnc.org/";
    license = lib.licenses.gpl2Plus;
    description = "High-speed version of VNC derived from TightVNC";
    maintainers = with lib.maintainers; [ nh2 ];
    platforms = with lib.platforms; linux;
    changelog = "https://github.com/TurboVNC/turbovnc/blob/${finalAttrs.version}/ChangeLog.md";
  };
})
