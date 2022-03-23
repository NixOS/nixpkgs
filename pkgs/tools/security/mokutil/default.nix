{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, openssl
, efivar
, keyutils
}:

stdenv.mkDerivation rec {
  pname = "mokutil";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "lcp";
    repo = pname;
    rev = version;
    sha256 = "sha256-dt41TCr6RkmE9H+NN8LWv3ogGsK38JtLjVN/b2mbGJs=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    efivar
    keyutils
  ];

  meta = with lib; {
    homepage = "https://github.com/lcp/mokutil";
    description = "Utility to manipulate machines owner keys";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nickcao ];
    platforms = platforms.linux;
  };
}
