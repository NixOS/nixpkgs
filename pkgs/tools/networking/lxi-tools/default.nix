{ lib, stdenv, fetchFromGitHub
, meson, ninja, cmake, pkg-config
, liblxi, readline, lua, bash-completion
, wrapGAppsHook
, glib, gtk4, gtksourceview5, libadwaita, json-glib
, desktop-file-utils, appstream-glib
, gsettings-desktop-schemas
, withGui ? false
}:

stdenv.mkDerivation rec {
  pname = "lxi-tools";
<<<<<<< HEAD
  version = "2.7";
=======
  version = "2.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "lxi-tools";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-69B3wW4lg6GxSpEKhuFYKTuAyd+QYb4WNbNVdZnRUt8=";
=======
    sha256 = "sha256-F9svLaQnQyVyC5KzDnaGwB8J/nBZ3zzOVwYNxWBPifU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    meson ninja cmake pkg-config
  ] ++ lib.optional withGui wrapGAppsHook;

  buildInputs = [
    liblxi readline lua bash-completion
  ] ++ lib.optionals withGui [
    glib gtk4 gtksourceview5 libadwaita json-glib
    desktop-file-utils appstream-glib
    gsettings-desktop-schemas
  ];

  postUnpack = "sed -i '/meson.add_install.*$/d' source/meson.build";

  mesonFlags = lib.optional (!withGui) "-Dgui=false";

  postInstall = lib.optionalString withGui
    "glib-compile-schemas $out/share/glib-2.0/schemas";

  meta = with lib; {
    description = "Tool for communicating with LXI compatible instruments";
    longDescription = ''
      lxi-tools is a collection of open source software tools
      that enables control of LXI compatible instruments such
      as modern oscilloscopes, power supplies,
      spectrum analyzers etc.
    '';
    homepage = "https://lxi-tools.github.io/";
    license = licenses.bsd3;
<<<<<<< HEAD
    platforms = platforms.unix;
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.vq ];
  };
}
