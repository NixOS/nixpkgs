{ lib
, stdenv
, autoconf-archive
, autoreconfHook
, fetchFromGitHub
, gtk3
, libtool
, pkg-config
, guiSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "libzbc";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "westerndigitalcorporation";
    repo = "libzbc";
    rev = "v${version}";
    sha256 = "qI09dkMCwMym3j1ELrFDNbNB5hW/CzwmFmZhUNDXsfI=";
  };

  nativeBuildInputs = [
    autoconf-archive # this can be removed with the next release
    autoreconfHook
    libtool
  ] ++ lib.optionals guiSupport [ pkg-config ];

  buildInputs = lib.optionals guiSupport [ gtk3 ];

  configureFlags = lib.optional guiSupport "--enable-gui";

  meta = with lib; {
    description = "ZBC device manipulation library";
    homepage = "https://github.com/westerndigitalcorporation/libzbc";
    maintainers = with maintainers; [ zseri ];
    license = with licenses; [ bsd2 lgpl3Plus ];
    platforms = platforms.linux;
  };
}
