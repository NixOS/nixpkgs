{ lib, stdenv, fetchFromGitHub, nix, readline, boehmgc }:

let rev = "f92408136ed08804bab14b3e2a2def9b8effd7eb"; in

stdenv.mkDerivation {
  name = "nix-repl-${lib.getVersion nix}-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-repl";
    inherit rev;
    sha256 = "1vl36d3n7hrw4vy2n358zx210ygkj4lmd8zsiifna6x7w7q388bj";
  };

  buildInputs = [ nix readline ];

  buildPhase = "true";

  # FIXME: unfortunate cut&paste.
  installPhase =
    ''
      mkdir -p $out/bin
      $CXX -O3 -Wall -std=c++0x \
        -o $out/bin/nix-repl nix-repl.cc \
        -I${nix}/include/nix \
        -lnixformat -lnixutil -lnixstore -lnixexpr -lnixmain -lreadline -lgc \
        -DNIX_VERSION=\"${(builtins.parseDrvName nix.name).version}\"
    '';

  meta = {
    homepage = https://github.com/edolstra/nix-repl;
    description = "An interactive environment for evaluating and building Nix expressions";
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.gpl3;
    platforms = nix.meta.platforms;
  };
}
