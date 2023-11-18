{ lib
, clangStdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, libimobiledevice
, libusb1
, avahi
, clang
}: let

  libgeneral = clangStdenv.mkDerivation rec {
    pname = "libgeneral";
    version = "unstable-2021-12-12";
    src = fetchFromGitHub {
      owner = "tihmstar";
      repo = pname;
      rev = "017d71edb0a12ff4fa01a39d12cd297d8b3d8d34";
      hash = "sha256-NrSl/BeKe3wahiYTHGRVSq3PLgQfu76kHCC5ziY7cgQ=";
    };
    postPatch = ''
      # Set package version so we don't require git
      sed -i '/AC_INIT/s/m4_esyscmd.*/${version})/' configure.ac
    '';
    nativeBuildInputs = [
      autoreconfHook
      pkg-config
    ];
    meta = with lib; {
      description = "Helper library used by usbmuxd2";
      homepage = "https://github.com/tihmstar/libgeneral";
      license = licenses.lgpl21;
      platforms = platforms.all;
    };
  };

in
clangStdenv.mkDerivation rec {
  pname = "usbmuxd2";
  version = "unstable-2022-02-07";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = pname;
    rev = "753b79eaf317c56df6c8b1fb6da5847cc54a0bb0";
    hash = "sha256-T9bt3KOJwFpdPeFuXfBhkBZNaNzix3Q3D47vASR+fVg=";
  };

  patches = [
    (fetchpatch {
      name = "libplist-2.3.0-compatibility.patch";
      url = "https://github.com/tihmstar/usbmuxd2/commit/e527bce2360afc22c95542f1252f94c994f45c72.patch";
      hash = "sha256-ig4j4z2HH8gitXxZYW9fm74Ix9XmJeX2Lz9HBCuDsuk=";
    })
  ];

  postPatch = ''
    # Set package version so we don't require git
    sed -i '/AC_INIT/s/m4_esyscmd.*/${version})/' configure.ac
    # Do not check libgeneral version
    sed -i 's/libgeneral >= 39/libgeneral/' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    clang
    pkg-config
  ];

  propagatedBuildInputs = [
    avahi
    libgeneral
    libimobiledevice
    libusb1
  ];

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  makeFlags = [
    "sbindir=${placeholder "out"}/bin"
  ];

  meta = with lib; {
    homepage = "https://github.com/tihmstar/usbmuxd2";
    description = "A socket daemon to multiplex connections from and to iOS devices";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
