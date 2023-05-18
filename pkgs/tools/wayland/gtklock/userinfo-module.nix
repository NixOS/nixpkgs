{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, gtk3
, glib
, accountsservice
}:

stdenv.mkDerivation rec {
  pname = "gtklock-userinfo-module";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7dtw6GZ7l0fbTxRxMWH4yRj9Zqz9KB3acmwnF/8LALg=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 glib accountsservice ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Gtklock module adding user info to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-powerbar-module";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
