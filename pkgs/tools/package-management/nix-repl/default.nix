{ stdenv, fetchgit, nix, readline, boehmgc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nix-repl-${getVersion nix}-${substring 0 7 src.rev}";

  src = fetchgit {
    url = https://github.com/edolstra/nix-repl.git;
    rev = "81d658fe4afda234028cd4551e12491db4303957";
    sha256 = "067mj8as99n0hkrr2qss3y3hnr8c5zy4n8bqx3z900n3j43cwzyc";
  };

  buildInputs = [ nix readline boehmgc ];

  buildPhase = "true";

  # FIXME: unfortunate cut&paste.
  installPhase =
    ''
      mkdir -p $out/bin
      g++ -O3 -Wall -std=c++0x \
        -o $out/bin/nix-repl nix-repl.cc \
        -I${nix}/include/nix -L${nix}/lib/nix \
        -lformat -lutil -lstore -lexpr -lmain -lreadline -lgc
    '';

  meta = {
    homepage = https://github.com/edolstra/nix-repl;
    description = "An interactive environment for evaluating and building Nix expressions";
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
