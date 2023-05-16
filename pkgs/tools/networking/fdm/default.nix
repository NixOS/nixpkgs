{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl, tdb, zlib, flex, bison }:

stdenv.mkDerivation rec {
  pname = "fdm";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "nicm";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Gqpz+N1ELU5jQpPJAG9s8J9UHWOJNhkT+s7+xuQazd0=";
=======
    sha256 = "sha256-Gqpz+N1ELU5jQpPJAG9s8J9UHWOJNhkT+s7+xuQazd0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl tdb zlib flex bison ];

<<<<<<< HEAD
  postInstall = ''
    install fdm-sanitize $out/bin
    mkdir -p $out/share/doc/${pname}
    install -m644 MANUAL $out/share/doc/${pname}
    cp -R examples $out/share/doc/${pname}
  '';
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Mail fetching and delivery tool - should do the job of getmail and procmail";
    maintainers = with maintainers; [ raskin ];
<<<<<<< HEAD
    platforms = with platforms; linux ++ darwin;
=======
    platforms = with platforms; linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/nicm/fdm";
    downloadPage = "https://github.com/nicm/fdm/releases";
    license = licenses.isc;
  };
}
