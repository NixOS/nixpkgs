{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, efivar
, keyutils
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "mokutil";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lcp";
    repo = pname;
    rev = version;
    sha256 = "sha256-vxSYwsQ+xjW7a7gZhvgX4lzA7my6BZCYGwE1bLceTQA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    efivar
    keyutils
    libxcrypt
  ];

  meta = with lib; {
    homepage = "https://github.com/lcp/mokutil";
    description = "Utility to manipulate machines owner keys";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
  };
}
