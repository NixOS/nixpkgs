{ lib
, stdenv
, fetchFromGitHub
, nixosTests

# Dependencies
, cmake
, libjpeg_turbo
, makeWrapper
, mesa # for built-in 3D software rendering using swrast
, openjdk # for the client with Java GUI
, openjdk_headless # for the server
, openssh
, openssl
, pam
, perl
, which
, xkbcomp
, xkeyboard_config
, xorg
}:

stdenv.mkDerivation rec {
  pname = "turbovnc";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "TurboVNC";
    repo = "turbovnc";
    rev = version;
    sha256 = "sha256-mEdatfTBx4nNmMTgv1Z+xefPFEiE2rCrsxyB7Dd03rg=";
  };

  # TODO:
  # * Build outputs that are unclear:
  #   * `-- FONT_ENCODINGS_DIRECTORY = /var/empty/share/X11/fonts/encodings`
  #     Maybe relevant what the tigervnc and tightvnc derivations
  #     do with their `fontDirectories`?
  #   * `SERVER_MISC_CONFIG_PATH = /var/empty/lib64/xorg`
  #   * The thing about xorg `protocol.txt`
  # * Does SSH support require `openssh` on PATH?
  # * Add `enableClient ? true` flag that disables the client GUI
  #   so that the server can be built without openjdk dependency.
  # * Perhaps allow to build the client on non-Linux platforms.

  nativeBuildInputs = [
    cmake
    makeWrapper
    openjdk_headless
  ];

  buildInputs = [
    libjpeg_turbo
    openssl
    pam
    perl
  ] ++ (with xorg; [
    libSM
    libX11
    libXext
    libXi
    xorgproto
  ]);

  cmakeFlags = [
    # For the 3D software rendering built into TurboVNC, pass the path
    # to the swrast dri driver in Mesa.
    # Can also be given at runtime to its `Xvnc` as:
    #   -dridir /nix/store/...-mesa-20.1.10-drivers/lib/dri/
    "-DDRI_DRIVER_PATH=${mesa.drivers}/lib/dri"
    # The build system doesn't find these files automatically.
    "-DTJPEG_JAR=${libjpeg_turbo.out}/share/java/turbojpeg.jar"
    "-DTJPEG_JNILIBRARY=${libjpeg_turbo.out}/lib/libturbojpeg.so"
    "-DXKB_BASE_DIRECTORY=${xkeyboard_config}/share/X11/xkb"
    "-DXKB_BIN_DIRECTORY=${xkbcomp}/bin"
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
    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${lib.makeBinPath [ which xorg.twm ]}

    # Patch /usr/bin/perl
    patchShebangs $out/bin/vncserver

    # vncserver needs `xauth`
    wrapProgram $out/bin/vncserver \
      --prefix PATH : ${lib.makeBinPath (with xorg; [ xauth ])}

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
  };
}
