{ stdenv, fetchgit, nix, readline, boehmgc }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "nix-repl-${getVersion nix}-${substring 0 7 src.rev}";

  src = fetchgit {
    url = https://github.com/edolstra/nix-repl.git;
    rev = "1734e8a1491ef831c83c2620b6b0f4a590b67c1f";
    sha256 = "12fld2780jh3ww2n59s9z7afwjkmfhwh4dqn3wjva4ff8fx3n0mf";
  };

  buildInputs = [ nix readline boehmgc ];

  buildPhase = "true";

  # FIXME: unfortunate cut&paste.
  installPhase =
    ''
      mkdir -p $out/bin
      g++ -O3 -Wall -std=c++0x \
        -o $out/bin/nix-repl nix-repl.cc \
        -I${nix}/include/nix \
        -lnixformat -lnixutil -lnixstore -lnixexpr -lnixmain -lreadline -lgc \
        -DNIX_VERSION=${(builtins.parseDrvName nix.name).version}
    '';

  meta = {
    homepage = https://github.com/edolstra/nix-repl;
    description = "An interactive environment for evaluating and building Nix expressions";
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
