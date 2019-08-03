{ stdenv
, fetchFromGitHub
, cmake
, sqlite
, botan2
, boost
, curl
, gettext
, pkgconfig
, libusb
, gnutls }:

stdenv.mkDerivation rec {
  name = "neopg-${version}";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "das-labor";
    repo = "neopg";
    rev = "v${version}";
    sha256 = "15xp5w046ix59cfrhh8ka4camr0d8qqw643g184sqrcqwpk7nbrx";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ cmake sqlite botan2 boost curl gettext libusb gnutls ];

  doCheck = true;
  checkTarget = "test";
  dontUseCmakeBuildDir = true;

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/3rdparty/googletest/googletest:$(pwd)/neopg
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
