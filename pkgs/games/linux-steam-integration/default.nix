{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, git, gtk, pkgs, gettext,
  gcc_multi, libressl, gnome3, steam }:

let
  version = "0.7.3";

in stdenv.mkDerivation rec {
  name = "linux-steam-integration-${version}";

  src = fetchFromGitHub {
    owner = "clearlinux";
    repo = "linux-steam-integration";
    rev = "v${version}";
    sha256 = "0brv3swx8h170ycxksb31sf5jvj85csfpx7gjlf6yrfz7jw2j6vp";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkgconfig git gettext gcc_multi ];
  buildInputs = [ gtk libressl ];

  # Patch lib paths (AUDIT_PATH and REDIRECT_PATH) in shim.c
  # Patch path to lsi-steam in lsi-steam.desktop
  # Patch path to zenity in lsi.c
  postPatch = ''
    substituteInPlace src/shim/shim.c --replace "/usr/" $out
    substituteInPlace data/lsi-steam.desktop --replace "/usr/" $out
    substituteInPlace src/lsi/lsi.c --replace zenity ${gnome3.zenity}/bin/zenity
    substituteInPlace data/lsi-settings.desktop.in \
      --replace "Name=Linux Steam Integration" "Name=Linux Steam Integration Settings"
  '';

  configurePhase = ''
    # Configure 64bit things
    meson build                           \
      -Dwith-shim=co-exist                \
      -Dwith-frontend=true                \
      -Dwith-steam-binary=${steam}/bin/steam \
      -Dwith-new-libcxx-abi=true          \
      -Dwith-libressl-mode=native         \
      --prefix /                          \
      --libexecdir lib                    \
      --libdir lib                        \
      --bindir bin

    # Configure 32bit things
    CC="gcc -m32" CXX="g++ -m32" meson build32 \
      -Dwith-shim=none                         \
      -Dwith-libressl-mode=native              \
      --prefix /                               \
      --libexecdir lib32                       \
      --libdir lib32
  '';

  buildPhase = ''
    # Build 64bit things
    ninja -C build

    # Build 32bit things
    ninja -C build32
  '';

  installPhase = ''
    DESTDIR="$out" ninja -C build install
    DESTDIR="$out" ninja -C build32 install
  '';

  meta = with stdenv.lib; {
    description = "Steam wrapper to improve compability and performance";
    longDescription = ''
      Linux Steam Integration is a helper system to make the Steam Client and
      Steam games run better on Linux. In a nutshell, LSI automatically applies
      various workarounds to get games working, and fixes long standing bugs in
      both games and the client
    '';
    homepage = https://github.com/clearlinux/linux-steam-integration;
    license = licenses.lgpl21;
    maintainers = [ maintainers.etu ];
    platforms = [ "x86_64-linux" ];
  };
}
