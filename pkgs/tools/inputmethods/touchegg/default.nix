{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, systemd
, libinput
, pugixml
, cairo
, xorg
, gtk3-x11
, pcre
, pkg-config
, cmake
, pantheon
, withPantheon ? false
}:

stdenv.mkDerivation rec {
  pname = "touchegg";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "sha256-2ZuFZ2PHhbxNTmGdlZONgPfEJC7lI5Rc6dgiBj7VG2o=";
  };

  patches = lib.optionals withPantheon [
    # Disable per-application gesture by default to make sure the default
    # config does not conflict with Pantheon switchboard settings.
    (fetchpatch {
      url = "https://github.com/elementary/os-patches/commit/7d9b133e02132d7f13cf2fe850b2fe4c015c3c5e.patch";
      sha256 = "sha256-ZOGVkxiXoTORXC6doz5r9IObAbYjhsDjgg3HtzlTSUc=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    systemd
    libinput
    pugixml
    cairo
    gtk3-x11
    pcre
  ] ++ (with xorg; [
    libX11
    libXtst
    libXrandr
    libXi
    libXdmcp
    libpthreadstubs
    libxcb
  ]);

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
