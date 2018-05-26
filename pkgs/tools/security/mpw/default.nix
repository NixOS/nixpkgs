{ stdenv, cmake, fetchFromGitHub, ncurses, libsodium, json_c }:

stdenv.mkDerivation rec {
  name = "mpw-2.6-f8043ae";

  src = fetchFromGitHub {
    owner = "Lyndir";
    repo = "MasterPassword";
    rev = "f8043ae16d73ddfb205aadd25c35cd9c5e95b228";
    sha256 = "0hy02ri7y3sca85z3ff5i68crwav5cjd7rrdqj7jrnpp1bw4yapi";
  };

  postUnpack = ''
    sourceRoot+=/platform-independent/cli-c
  '';

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace curses ncurses
    echo ${name} > VERSION
  '';

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ ncurses libsodium json_c ];

  installPhase = ''
    mkdir -p $out/bin
    mv mpw $out/bin/mpw
  '';

  meta = with stdenv.lib; {
    homepage = https://masterpasswordapp.com/;
    description = "A stateless password management solution";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
