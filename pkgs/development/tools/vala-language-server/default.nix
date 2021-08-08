{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, scdoc
, gnome-builder
, gnused
, glib
, libgee
, json-glib
, jsonrpc-glib
, vala
}:

stdenv.mkDerivation rec {
  pname = "vala-language-server";
  version = "0.48.3";

  src = fetchFromGitHub {
    owner = "Prince781";
    repo = pname;
    rev = version;
    sha256 = "sha256-MhVwK4RtEAJcwcJe71ganCaXQHa9jzxyknzc9kJi274=";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    # GNOME Builder Plugin
    gnused
    gnome-builder
  ];

  buildInputs = [
    glib
    libgee
    json-glib
    jsonrpc-glib
    vala
  ];

  meta = with lib; {
    description = "Code Intelligence for Vala & Genie";
    homepage = "https://github.com/Prince781/vala-language-server";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ andreasfelix ];
    platforms = platforms.linux;
  };
}
