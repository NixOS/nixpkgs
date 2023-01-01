{ lib
, stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation {
  pname = "murmur3";
  version = "71a75d57ca4e7ca0f7fc2fd84abd93595b0624ca";
  src = fetchFromGitHub {
    owner = "urbit";
    repo = "murmur3";
    rev = "71a75d57ca4e7ca0f7fc2fd84abd93595b0624ca";
    sha256 = "0k7jq2nb4ad9ajkr6wc4w2yy2f2hkwm3nkbj2pklqgwsg6flxzwg";
  };

  buildPhase = ''
    $CC -fPIC -O3 -o murmur3.o -c $src/murmur3.c
  '';

  installPhase = ''
    mkdir -p $out/{lib,include}
    $AR rcs $out/lib/libmurmur3.a murmur3.o
    cp $src/*.h $out/include/
  '';

  meta = {
    description = "C port of Murmur3 hash";
    homepage = "https://github.com/urbit/murmur3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.uningan ];
    platforms = lib.platforms.unix;
  };
}
