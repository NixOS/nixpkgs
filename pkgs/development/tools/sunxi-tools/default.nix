{ stdenv, fetchFromGitHub, pkgconfig, libusb, zlib }:

stdenv.mkDerivation {
  name = "sunxi-tools-20181113";

  src = fetchFromGitHub {
    owner = "linux-sunxi";
    repo = "sunxi-tools";
    rev = "6d598a0ed714201380e78130213500be6512942b";
    sha256 = "1yhl6jfl2cws596ymkyhm8h9qkcvp67v8hlh081lsaqv1i8j9yig";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb zlib ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildFlags = [ "tools" "misc" ];

  installTargets = [ "install-tools" "install-misc" ];

  meta = with stdenv.lib; {
    description = "Tools for Allwinner SoC devices";
    homepage = http://linux-sunxi.org/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ elitak ];
  };
}
