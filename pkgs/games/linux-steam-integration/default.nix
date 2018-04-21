{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, git, gtk, pkgs, gettext,
  gcc_multi, libressl }:

let
  version = "0.7.2";
  steamBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ steam ])}/steam";
  zenityBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ gnome3.zenity ])}/zenity";

in stdenv.mkDerivation rec {
  name = "linux-steam-integration-${version}";

  nativeBuildInputs = [ meson ninja pkgconfig git gettext gcc_multi ];
  buildInputs = [ gtk libressl ];

  src = fetchFromGitHub {
    owner = "solus-project";
    repo = "linux-steam-integration";
    rev = "v${version}";
    sha256 = "0yn71fvjqi63dxk04jsndb26pgipl0nla10sy94bi7q95pk3sdf6";
    fetchSubmodules = true;
  };

  # Patch lib paths (AUDIT_PATH and REDIRECT_PATH) in shim.c
  # Patch path to lsi-steam in lsi-steam.desktop
  # Patch path to zenity in lsi.c
  postPatch = ''
    sed -i -e "s|/usr/|$out/|g" src/shim/shim.c
    sed -i -e "s|/usr/|$out/|g" data/lsi-steam.desktop
    sed -i -e "s|zenity|${zenityBinPath}|g" src/lsi/lsi.c
    sed -i -e "s|Name=Linux Steam Integration|Name=Linux Steam Integration Settings|" data/lsi-settings.desktop.in

  '';

  configurePhase = ''
    # Configure 64bit things
    meson build                           \
      -Dwith-shim=co-exist                \
      -Dwith-frontend=true                \
      -Dwith-steam-binary=${steamBinPath} \
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
    homepage = https://github.com/solus-project/linux-steam-integration;
    license = licenses.lgpl21;
    maintainers = [ maintainers.etu ];
    platforms = [ "x86_64-linux" ];
  };
}
