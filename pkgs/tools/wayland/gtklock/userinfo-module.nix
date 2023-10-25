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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WNUX0wRoh14rZRmiyQEGZPKJRr6oNW8B6LEwhDSPcyY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 glib accountsservice ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Gtklock module adding user info to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-userinfo-module";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
