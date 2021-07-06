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
}:

stdenv.mkDerivation rec {
  pname = "gamemode";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "FeralInteractive";
    repo = pname;
    rev = version;
    sha256 = "sha256-P00OnZiPZyxBu9zuG+3JNorXHBhJZy+cKPjX+duZrJ0=";
  };

  outputs = [ "out" "dev" "lib" "man" "static" ];

  patches = [
    # Run executables from PATH instead of /usr/bin
    # See https://github.com/FeralInteractive/gamemode/pull/323
    (fetchpatch {
      url = "https://github.com/FeralInteractive/gamemode/commit/be44b7091baa33be6dda60392e4c06c2f398ee72.patch";
      sha256 = "TlDUETs4+N3pvrVd0FQGlGmC+6ByhJ2E7gKXa7suBtE=";
    })

    # Fix loading shipped config when using a prefix other than /usr
    # See https://github.com/FeralInteractive/gamemode/pull/324
    (fetchpatch {
      url = "https://github.com/FeralInteractive/gamemode/commit/b29aa903ce5acc9141cfd3960c98ccb047eca872.patch";
      sha256 = "LwBzBJQ7dfm2mFVSOSPjJP+skgV5N6h77i66L1Sq+ZM=";
    })

    # Add @libraryPath@ template variable to fix loading the PRELOAD library
    ./preload-nix-workaround.patch
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
  checkInputs = [
    appstream
  ];

  # Move static libraries to $static so $lib only contains dynamic libraries.
  postInstall = ''
    moveToOutput lib/*.a "$static"
  '';

  # Add $lib/lib to gamemoded & gamemode-simulate-game's rpath since
  # they use dlopen to load libgamemode. Can't use makeWrapper since
  # it would break the security wrapper in the NixOS module.
  postFixup = ''
    for bin in "$out/bin/gamemoded" "$out/bin/gamemode-simulate-game"; do
      patchelf --set-rpath "$lib/lib:$(patchelf --print-rpath "$bin")" "$bin"
    done
  '';

  meta = with lib; {
    description = "Optimise Linux system performance on demand";
    homepage = "https://github.com/FeralInteractive/GameMode";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
