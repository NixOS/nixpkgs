{ autoreconfHook
, fetchFromGitHub
, gensio
, lib
, libyaml
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ser2net";
<<<<<<< HEAD
  version = "4.5.0";
=======
  version = "4.3.12";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AmTJfjLpnPHtPMKP9djKTZozNPkojPqRJ3eoypY53bA=";
=======
    hash = "sha256-jF1tk/JeZ3RGHol+itwtkTF/cn5FHm/vhUgXJzi9J9E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://github.com/cminyard/ser2net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
