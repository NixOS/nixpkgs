{ lib, stdenv, fetchFromGitLab, pkg-config, wrapGAppsHook
, withLibui ? true, gtk3
, withUdisks ? stdenv.isLinux, udisks, glib
, libX11 }:

stdenv.mkDerivation rec {
  pname = "usbimager";
  version = "1.0.9";

  src = fetchFromGitLab {
    owner = "bztsrc";
    repo = pname;
    rev = version;
    sha256 = "sha256-CEGUXJXqXmD8uT93T9dg49Lf5vTpAzQjdnhYmbR5zTI=";
  };

<<<<<<< HEAD
  sourceRoot = "${src.name}/src";
=======
  sourceRoot = "source/src/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = lib.optionals withUdisks [ udisks glib ]
    ++ lib.optional (!withLibui) libX11
    ++ lib.optional withLibui gtk3;
<<<<<<< HEAD
    # libui is bundled with the source of usbimager as a compiled static library
=======
    # libui is bundled with the source of usbimager as a compiled static libary
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    sed -i \
      -e 's|install -m 2755 -g disk|install |g' \
      -e 's|-I/usr/include/gio-unix-2.0|-I${glib.dev}/include/gio-unix-2.0|g' \
      -e 's|install -m 2755 -g $(GRP)|install |g' Makefile
  '';

  dontConfigure = true;

  makeFlags =  [ "PREFIX=$(out)" ]
    ++ lib.optional withLibui "USE_LIBUI=yes"
    ++ lib.optional withUdisks "USE_UDISKS2=yes";

  meta = with lib; {
    description = "A very minimal GUI app that can write compressed disk images to USB drives";
    homepage = "https://gitlab.com/bztsrc/usbimager";
    license = licenses.mit;
    maintainers = with maintainers; [ vdot0x23 ];
    # windows and darwin could work, but untested
    # feel free add them if you have a machine to test
    platforms = with platforms; linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
