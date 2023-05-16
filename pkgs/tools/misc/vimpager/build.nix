{ lib, stdenv
, fetchFromGitHub
, coreutils
, sharutils
<<<<<<< HEAD
=======
, runtimeShell
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, version
, sha256
}:

stdenv.mkDerivation {
  inherit version;
  pname = "vimpager";

  src = fetchFromGitHub {
    inherit sha256;

    owner  = "rkitover";
    repo   = "vimpager";
    rev    = version;
  };

  nativeBuildInputs = [ sharutils ]; # for uuencode
  buildInputs = [ coreutils ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  buildPhase = ''
    sed -i 's,/bin/cat,${coreutils}/bin/cat,g' vimpager
    make
  '';


  meta = with lib; {
    description = "Use Vim as PAGER";
    homepage    = "https://www.vim.org/scripts/script.php?script_id=1723";
    license     = with licenses; [ bsd2 mit vim ];
    platforms   = platforms.unix;
  };
}
