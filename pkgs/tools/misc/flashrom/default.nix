{ fetchurl
, fetchpatch
, stdenv
, installShellFiles
, lib
, libftdi1
, libjaylink
, libusb1
, pciutils
, pkg-config
, jlinkSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "flashrom";
  version = "1.2";

  src = fetchurl {
    url = "https://download.flashrom.org/releases/flashrom-v${version}.tar.bz2";
    sha256 = "0ax4kqnh7kd3z120ypgp73qy1knz47l6qxsqzrfkd97mh5cdky71";
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ libftdi1 libusb1 pciutils ]
    ++ lib.optional jlinkSupport libjaylink;

  patches = [
    # remove when updating from 1.2
    (fetchpatch {
      name = "fix-aarch64-build.patch";
      url = "https://github.com/flashrom/flashrom/commit/da6b3b70cb852dd8e9f9e21aef95fa83e7f7ab0d.patch";
      sha256 = "sha256-fXYDXgT/ik+qtxxFEyJ7/axtycbwLkEg0UD+hzsYEwg=";
    })
    # fix build with gcc 10
    (fetchpatch {
      url = "https://github.com/flashrom/flashrom/commit/3a0c1966e4c66f91e6e8551e906b6db38002acb4.patch";
      sha256 = "sha256-UfXLefMS20VUc7hk4IXECFbDWEbBnHMGSzOYemTfvjI=";
    })
  ];

  postPatch = ''
    substituteInPlace util/z60_flashrom.rules \
      --replace "plugdev" "flashrom"
  '';

  makeFlags = [ "PREFIX=$(out)" "libinstall" ]
    ++ lib.optional jlinkSupport "CONFIG_JLINK_SPI=yes";

  postInstall = ''
    install -Dm644 util/z60_flashrom.rules $out/lib/udev/rules.d/flashrom.rules
  '';

  meta = with lib; {
    homepage = "https://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fpletz felixsinger ];
    platforms = platforms.all;
    broken = stdenv.isDarwin; # requires DirectHW
  };
}
