{ stdenv, lib
, fetchFromGitHub
, fetchpatch
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
  version = "2.0.12";
  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "sha256-oJzehs7oLFTDn7GSm6bY/77tEfyEdlANn69EdCApdPA=";
  };

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

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

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  patches = lib.optionals withPantheon [
    # Disable per-application gesture by default to make sure the default
    # config does not conflict with Pantheon switchboard settings.
    (fetchpatch {
      url = "https://github.com/elementary/os-patches/commit/ada4e726540a2bb57b606c98e2531cfaaea57211.patch";
      sha256 = "0is9acwvgiqdhbiw11i3nq0rp0zldcza779fbj8k78cp329rbqb4";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
