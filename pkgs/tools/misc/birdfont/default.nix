{ stdenv, fetchurl, pkgconfig, python3, xmlbird,
cairo, gdk-pixbuf, libgee, glib, gtk3, webkitgtk, libnotify, sqlite, vala_0_44,
gobject-introspection, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "birdfont";
  version = "2.29.1";

  src = fetchurl {
    url = "https://birdfont.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0620bppcbm9pb8l0d4sc56gfwkr97gw4zjirjz5ikk5lj0m801yi";
  };

  nativeBuildInputs = [ python3 pkgconfig vala_0_44 gobject-introspection wrapGAppsHook ];
  buildInputs = [ xmlbird libgee cairo gdk-pixbuf glib gtk3 webkitgtk libnotify sqlite gsettings-desktop-schemas ];

  postPatch = ''
    substituteInPlace install.py \
      --replace 'platform.version()' '"Nix"'

    patchShebangs .
  '';

  buildPhase = "./build.py";

  installPhase = "./install.py";

  meta = with stdenv.lib; {
    description = "Font editor which can generate fonts in TTF, EOT, SVG and BIRDFONT format";
    homepage = "https://birdfont.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
  };
}
