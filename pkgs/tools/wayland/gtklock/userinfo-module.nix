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
<<<<<<< HEAD
  version = "2.1.0";
=======
  version = "2.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-WNUX0wRoh14rZRmiyQEGZPKJRr6oNW8B6LEwhDSPcyY=";
=======
    hash = "sha256-7dtw6GZ7l0fbTxRxMWH4yRj9Zqz9KB3acmwnF/8LALg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 glib accountsservice ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Gtklock module adding user info to the lockscreen";
<<<<<<< HEAD
    homepage = "https://github.com/jovanlanik/gtklock-userinfo-module";
=======
    homepage = "https://github.com/jovanlanik/gtklock-powerbar-module";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
