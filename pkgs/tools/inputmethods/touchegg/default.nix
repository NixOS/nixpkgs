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
  version = "2.0.15";

  src = fetchFromGitHub {
    owner = "JoseExposito";
    repo = pname;
    rev = version;
    sha256 = "sha256-oz3+hNNjQ/5vXWPMuhA2N2KK8W8S42WeSeDbhV4oJ9M=";
  };

  patches = lib.optionals withPantheon [
    # Required for the next patch to apply
    # Reverts https://github.com/JoseExposito/touchegg/pull/603
    (fetchpatch {
      url = "https://github.com/JoseExposito/touchegg/commit/34e947181d84620021601e7f28deb1983a154da8.patch";
      sha256 = "sha256-qbWwmEzVXvDAhhrGvMkKN4YNtnFfRW+Yra+i6VEQX4g=";
      revert = true;
    })
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/JoseExposito/touchegg";
    description = "Linux multi-touch gesture recognizer";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
