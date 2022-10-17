{ lib, stdenv, fetchFromGitHub, bison, flex }:

stdenv.mkDerivation rec {
  pname = "mceinject";
  version = "unstable-2013-01-19";

  src = fetchFromGitHub {
    owner  = "andikleen";
    repo   = "mce-inject";
    rev    = "4cbe46321b4a81365ff3aafafe63967264dbfec5";
    sha256 = "0gjapg2hrlxp8ssrnhvc19i3r1xpcnql7xv0zjgbv09zyha08g6z";
  };

  nativeBuildInputs = [ flex bison ];

  NIX_CFLAGS_COMPILE = "-Os -g -Wall";

  NIX_LDFLAGS = [ "-lpthread" ];

  makeFlags = [ "prefix=" ];

  enableParallelBuilding = true;

  installFlags = [ "destdir=$(out)" "manprefix=/share" ];

  meta = with lib; {
    description = "A tool to inject machine checks into x86 kernel for testing";
    longDescription = ''
      mce-inject allows to inject machine check errors on the software level
      into a running Linux kernel. This is intended for validation of the
      kernel machine check handler.
    '';
    homepage = "https://github.com/andikleen/mce-inject/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ arkivm ];
    platforms = platforms.linux;
  };
}
