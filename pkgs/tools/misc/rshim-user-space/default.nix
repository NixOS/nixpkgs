{ stdenv
, lib
, fetchFromGitHub
, autoconf
, automake
, pkg-config
, pciutils
, libusb1
, fuse
}:

stdenv.mkDerivation rec {
  pname = "rshim-user-space";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = pname;
    rev = "rshim-${version}";
    hash = "sha256-LbAs4IFfYT6OhrtwRXmuQR9rD7ulmmUB20Au5fO8j9w=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  buildInputs = [
    pciutils
    libusb1
    fuse
  ];

  strictDeps = true;

  preConfigure = "./bootstrap.sh";

  installPhase = ''
    mkdir -p "$out"/bin
    cp -a src/rshim "$out"/bin/
  '';

  meta = with lib; {
    description = "user-space rshim driver for the BlueField SoC";
    longDescription = ''
      The rshim driver provides a way to access the rshim resources on the
      BlueField target from external host machine. The current version
      implements device files for boot image push and virtual console access.
      It also creates virtual network interface to connect to the BlueField
      target and provides a way to access the internal rshim registers.
    '';
    homepage = "https://github.com/Mellanox/rshim-user-space";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nikstur ];
  };
}
