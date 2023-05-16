{ fetchFromGitHub, perl, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "sec";
<<<<<<< HEAD
  version = "2.9.2";
=======
  version = "2.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "simple-evcorr";
    repo = "sec";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-s5xalQfZIrvj8EcLvN0swpYBgRhE1YUoPmQYVFB0lWA=";
=======
    sha256 = "sha256-DKbh6q0opf749tbGsDMVuI5G2UV7faCHUfddH3SGOpo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ perl ];

  dontBuild = false;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    cp sec $out/bin
    cp sec.man $out/share/man/man1/sec.1
  '';

  meta = {
    homepage = "https://simple-evcorr.github.io";
    license = lib.licenses.gpl2;
    description = "Simple Event Correlator";
    maintainers = [ lib.maintainers.tv ];
    platforms = lib.platforms.all;
  };
}
