{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bgpq4";
<<<<<<< HEAD
  version = "1.11";
=======
  version = "1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bgp";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-Mz26YWrVXiTOWywouehpTQ7PaakaXUsIHH+47m8vXDo=";
=======
    sha256 = "sha256-9uFfE3rUQCYbWhtJuRQT9FHf9YeD4THkj/OCp9f1MwI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = with lib; {
    description = "BGP filtering automation tool";
    homepage = "https://github.com/bgp/bgpq4";
    license = licenses.bsd2;
    maintainers = with maintainers; [ vincentbernat ];
    platforms = with platforms; unix;
  };
}
