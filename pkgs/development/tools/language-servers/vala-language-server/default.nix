{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, meson
, ninja
, pkg-config
, scdoc
, gnome-builder
, glib
, libgee
, json-glib
, jsonrpc-glib
, vala
}:

stdenv.mkDerivation rec {
  pname = "vala-language-server";
  version = "0.48.5";

  src = fetchFromGitHub {
    owner = "vala-lang";
    repo = pname;
    rev = version;
    sha256 = "sha256-gntGnz8uqGz2EGwWWyty/N1ImaUKAPtXVZcjgp73SQM=";
  };

  patches = [
    # Fix regex for links in comments
    # https://github.com/vala-lang/vala-language-server/pull/268
    (fetchpatch {
      url = "https://github.com/vala-lang/vala-language-server/commit/b6193265d68b90755d57938c2ba1895841cf4b36.patch";
      sha256 = "sha256-nWG+xQAPDVBXamuKQymvn/FBHEP7Ta9p/vhYjxxBGzI=";
    })
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    # GNOME Builder Plugin
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
    homepage = "https://github.com/vala-lang/vala-language-server";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ andreasfelix ];
    platforms = platforms.linux;
  };
}
