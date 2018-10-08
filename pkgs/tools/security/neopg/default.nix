{ stdenv
, fetchFromGitHub
, cmake
, sqlite
, botan2
, boost164
, curl
, gettext
, pkgconfig
, libusb
, gnutls }:

stdenv.mkDerivation rec {
  name = "neopg-${version}";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "das-labor";
    repo = "neopg";
    rev = "v${version}";
    sha256 = "1ky3pwg6w8kyaa9iksfx6rryva87mbj1h3yi2mrzp2h7jhrfffpp";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ cmake sqlite botan2 boost164 curl gettext libusb gnutls ];

  doCheck = true;
  checkTarget = "test";

  postInstall = ''
    mkdir -p $out/bin
    cp src/neopg $out/bin/neopg
  '';

  meta = with stdenv.lib; {
    homepage = https://neopg.io/;
    description = "Modern replacement for GnuPG 2";
    license = licenses.gpl3;
    longDescription = ''
      NeoPG starts as an opiniated fork of GnuPG 2 to clean up the code and make it easier to develop.
      It is written in C++11.
    '';
    maintainers = with maintainers; [ erictapen ];
    platforms = platforms.linux;
  };
}
