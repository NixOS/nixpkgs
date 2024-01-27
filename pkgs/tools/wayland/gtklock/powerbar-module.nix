{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "gtklock-powerbar-module";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Ev6vjtvUSqP/+xTDRAqSYJ436WhZUtFRxSP7LoSK00w=";
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
