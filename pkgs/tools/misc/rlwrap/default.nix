{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "rlwrap-0.37";

  src = fetchurl {
    url = "http://utopia.knoware.nl/~hlub/uck/rlwrap/${name}.tar.gz";
    sha256 = "1gcb95i839pwn9a3phs2wq7bwz9f6v8sydq6lf9y4gm3hk0s40w4";
  };

  buildInputs = [ readline ];

  meta = {
    description = "Readline wrapper for console programs";
    homepage = http://utopia.knoware.nl/~hlub/uck/rlwrap/;
  };
}
