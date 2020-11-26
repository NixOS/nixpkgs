{ stdenv
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
  version = "0.48.1";

  src = fetchFromGitHub {
    owner = "benwaffle";
    repo = pname;
    rev = version;
    sha256 = "12k095052jkvbiyz8gzkj6w7r7p16d5m18fyikl48yvh5nln8fw0";
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

  meta = with stdenv.lib; {
    description = "Code Intelligence for Vala & Genie";
    homepage = "https://github.com/benwaffle/vala-language-server";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ andreasfelix worldofpeace ];
    platforms = platforms.linux;
  };
}
