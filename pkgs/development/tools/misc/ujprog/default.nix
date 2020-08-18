{ stdenv
, fetchFromGitHub
, pkgconfig
, libftdi
, libusb-compat-0_1
}:

stdenv.mkDerivation {
  name = "ujprog";
  version = "3.0.92";

  src = fetchFromGitHub {
    owner = "f32c";
    repo = "tools";
    rev = "0698352b0e912caa9b8371b8f692e19aac547a69";
    sha256 = "05gqvhg2yydvkfhzfr1kxr89amfzyvrnvx2pgnzi7qb2wljsj21a";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    libftdi
    libusb-compat-0_1
  ];

  # The Mac OS X Makefile is more portable and better suited to NixOS across all platforms because,
  # unlike the Linux Makefile, it does not rely on explicit /usr/lib* library paths.
  unpackPhase = ''
    cp $src/ujprog/Makefile.osx Makefile
    cp $src/ujprog/ujprog.c .
  '';

  buildPhase = ''
    make ujprog
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ujprog $out/bin/ujprog
  '';

  meta = with stdenv.lib; {
    description = "JTAG Programmer for the ULX3S and ULX2S open hardware FPGA development boards.";
    homepage = "https://github.com/f32c/tools";
    license = licenses.bsd2;
    maintainers = with maintainers; [ trepetti ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
