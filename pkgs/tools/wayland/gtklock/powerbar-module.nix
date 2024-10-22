{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gtklock-powerbar-module";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uqGWr3/PaXif+JuxqRDlvfeiVG2nbausfe5dZOHcm7o=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Gtklock module adding power controls to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-powerbar-module";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
