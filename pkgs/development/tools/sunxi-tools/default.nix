{ stdenv, fetchFromGitHub, pkgconfig, libusb, zlib }:

stdenv.mkDerivation {
  name = "sunxi-tools-20171130";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "5c1971040c6c44caefb98e371bfca9e18d511da9";
    sha256 = "0qzm515i3dfn82a6sf7372080zb02d365z52bh0b1q711r4dvjgp";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "tools" "misc" ];

  installTargets = [ "install-tools" "install-misc" ];

  meta = with stdenv.lib; {
    description = "Tools for Allwinner A10 devices";
    homepage = http://linux-sunxi.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
