{ lib
, stdenv
, fetchFromGitHub
, nixosTests

# Dependencies
, bzip2
, cmake
, freetype
, libGL
, libjpeg_turbo
, makeWrapper
, mesa # for built-in 3D software rendering using swrast
, openjdk # for the client with Java GUI
, openjdk_headless # for the server
, openssh
, openssl
, pam
, perl
, pkg-config
, python3
, which
, xkbcomp
, xkeyboard_config
, xorg
, xterm
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "turbovnc";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "TurboVNC";
    repo = "turbovnc";
    rev = finalAttrs.version;
    hash = "sha256-bU23sCjU3lUQszqyLHjKTxUKj0ngkkrUb8xYi9XSFj0=";
  };

  # TODO:
  # * Build outputs that are unclear:
  #   * `-- FONT_ENCODINGS_DIRECTORY = /var/empty/share/X11/fonts/encodings`
  #     Maybe relevant what the tigervnc and tightvnc derivations
  #     do with their `fontDirectories`?
  #   * `XORG_REGISTRY_PATH = /var/empty/lib64/xorg`
  #   * The thing about xorg `protocol.txt`
  # * Does SSH support require `openssh` on PATH?
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
    freetype
    libGL # for -DTVNC_SYSTEMX11=1
    libjpeg_turbo
    openssl
    pam
    perl
    zlib
  ] ++ (with xorg; [
    libfontenc # for -DTVNC_SYSTEMX11=1
    libSM
    libX11
    libXdamage # for -DTVNC_SYSTEMX11=1
    libXdmcp # for -DTVNC_SYSTEMX11=1
    libXext
    libXfont2 # for -DTVNC_SYSTEMX11=1
    libxkbfile # for -DTVNC_SYSTEMX11=1
    libXi
    mesa # for -DTVNC_SYSTEMX11=1
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
    "-DXORG_DRI_DRIVER_PATH=${mesa.driverLink}/lib/dri"
    # The build system doesn't find these files automatically.
    "-DTJPEG_JAR=${libjpeg_turbo.out}/share/java/turbojpeg.jar"
    "-DTJPEG_JNILIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so"
    "-DXKB_BASE_DIRECTORY=${xkeyboard_config}/share/X11/xkb"
    "-DXKB_BIN_DIRECTORY=${xkbcomp}/bin"
    # use system libs
    "-DTVNC_SYSTEMLIBS=1"
    "-DTVNC_SYSTEMX11=1"
    "-DTVNC_DLOPENSSL=0"
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
      --prefix PATH : ${lib.makeBinPath [ which xorg.twm xorg.xauth xterm ]}

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
