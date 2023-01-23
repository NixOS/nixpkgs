{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, json-glib
, gtk4
, libxml2
, gobject-introspection
, pkg-config
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "text-engine";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YSG4Vk3hrmtaJkK1WAlQcdgiDdgC4Un0t6UdaoIcUes=";
  };

  nativeBuildInputs = [ gobject-introspection gtk4 meson ninja pkg-config ];

  buildInputs = [ libadwaita json-glib libxml2 ];

  meta = with lib; {
    description = "Rich text framework for GTK";
    homepage = "https://github.com/mjakeman/text-engine";
    license = with licenses; [ mpl20 lgpl21Plus ];
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
