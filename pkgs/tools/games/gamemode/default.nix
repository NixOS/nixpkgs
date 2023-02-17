{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, libgamemode32
, meson
, ninja
, pkg-config
, dbus
, inih
, systemd
, appstream
, makeWrapper
, findutils
, gawk
, procps
}:

stdenv.mkDerivation rec {
  pname = "gamemode";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = pname;
    rev = version;
    sha256 = "sha256-DIFcmWFkoZOklo1keYcCl6n2GJgzWKC8usHFcJmfarU=";
  };

  outputs = [ "out" "dev" "lib" "man" "static" ];

  patches = [
    # Add @libraryPath@ template variable to fix loading the PRELOAD library
    ./preload-nix-workaround.patch
    # Do not install systemd sysusers configuration
    ./no-install-systemd-sysusers.patch
  ];

  postPatch = ''
    substituteInPlace data/gamemoderun \
      --subst-var-by libraryPath ${lib.makeLibraryPath ([
        (placeholder "lib")
      ] ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-linux") [
        # Support wrapping 32bit applications on a 64bit linux system
        libgamemode32
      ])}
  '';

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dbus
    inih
    systemd
  ];

  mesonFlags = [
    # libexec is just a way to package binaries without including them
    # in PATH. It doesn't make sense to install them to $lib
    # (the default behaviour in the meson hook).
    "--libexecdir=${placeholder "out"}/libexec"

    "-Dwith-systemd-user-unit-dir=lib/systemd/user"
  ];

  doCheck = true;
  nativeCheckInputs = [
    appstream
  ];

  # Move static libraries to $static so $lib only contains dynamic libraries.
  postInstall = ''
    moveToOutput lib/*.a "$static"
  '';

  postFixup = ''
    # Add $lib/lib to gamemoded & gamemode-simulate-game's rpath since
    # they use dlopen to load libgamemode. Can't use makeWrapper since
    # it would break the security wrapper in the NixOS module.
    for bin in "$out/bin/gamemoded" "$out/bin/gamemode-simulate-game"; do
      patchelf --set-rpath "$lib/lib:$(patchelf --print-rpath "$bin")" "$bin"
    done

    wrapProgram "$out/bin/gamemodelist" \
      --prefix PATH : ${lib.makeBinPath [
        findutils
        gawk
        procps
      ]}
  '';

  meta = with lib; {
    description = "Optimise Linux system performance on demand";
    homepage = "https://github.com/FeralInteractive/GameMode";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
