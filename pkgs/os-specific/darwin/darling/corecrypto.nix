{stdenv, lib, fetchFromGitHub, cmake, bison, flex}:

stdenv.mkDerivation rec {
  pname = "darling-corecrypto";
  name = pname;

  src = fetchFromGitHub {
    repo = pname;
    owner = "darlinghq";
    rev = "4dd1c763a651ad63a0e5365fbc6687e843221049";
    sha256 = "0f88xi8494zd0p3s6nkjl22ycinvcsr0chbcmlbdnpwwilhgxdq1";
  };

  # buildInputs = [ cmake ];

  buildPhase = ''
    for f in src/*.c; do
      cc -c $f -Iinclude -o ''${f%.c}.o
    done
    cc -dynamiclib -flat_namespace src/*.o -o libcorecrypto.dylib
    ar -cvq libcorecrypto.a src/*.o
  '';

  installPhase = ''
    mkdir -p $out
    cp -r include $out
    mkdir -p $out/lib
    cp libcorecrypto.* $out/lib
  '';

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl3;
    description = "CoreCrypto reimplementation under GPL-3";
    platforms = platforms.unix;
  };
}
