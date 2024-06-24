{ lib
, stdenv
, autoreconfHook
, fetchFromGitHub
, gtk3
, libtool
, pkg-config
, guiSupport ? false
}:

stdenv.mkDerivation rec {
  pname = "libzbc";
  version = "5.14.0";

  src = fetchFromGitHub {
    owner = "westerndigitalcorporation";
    repo = "libzbc";
    rev = "v${version}";
    sha256 = "sha256-+MBk2ZUr3Vt6pZFb4gTXMOzKBlf1EXMF8y/c1iDrIZM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
  ] ++ lib.optionals guiSupport [ pkg-config ];

  buildInputs = lib.optionals guiSupport [ gtk3 ];

  configureFlags = lib.optional guiSupport "--enable-gui";

  meta = with lib; {
    description = "ZBC device manipulation library";
    homepage = "https://github.com/westerndigitalcorporation/libzbc";
    maintainers = [ ];
    license = with licenses; [ bsd2 lgpl3Plus ];
    platforms = platforms.linux;
  };
}
