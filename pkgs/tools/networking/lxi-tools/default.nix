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
  version = "2.4";

  src = fetchFromGitHub {
    owner = "lxi-tools";
    repo = "lxi-tools";
    rev = "v${version}";
    sha256 = "sha256-1CuE/OuClVqw8bG1N8DFNqqQGmXyGyk1LICrcHyuVxw=";
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
    platforms = platforms.linux;
    maintainers = [ maintainers.vq ];
  };
}
