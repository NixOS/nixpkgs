{ stdenv, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  name = "ipad_charge-${version}";
  version = "2015-02-03";

  src = fetchFromGitHub {
    sha256 = "0f40hqx1dbqpwrhyf42h5982jwqv8j5zp5hwwakz6600hyqvnnz7";
    rev = "bb24e1c3a79016cfdffb9d28189485766d655ec6";
    repo = "ipad_charge";
    owner = "mkorenkov";
  };

  buildInputs = [ libusb1 ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace " -o root -g root" "" \
      --replace "/usr" "$out"
    sed "/rules\.d/d" -i Makefile
  '';

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Apple device USB charging utility for Linux";
    longDescription = ''
      USB charging control utility used to enable/disable charging of an Apple
      device connected to USB port. For a list of supported devices, see
      https://github.com/mkorenkov/ipad_charge#supported-devices.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
