{ lib, stdenv, fetchFromGitHub, nix, readline, boehmgc }:

let rev = "45c6405a30bd1b2cb8ad6a94b23be8b10cf52069"; in

stdenv.mkDerivation {
  name = "nix-repl-${lib.getVersion nix}-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-repl";
    inherit rev;
    sha256 = "0c6sifpz8j898xznvy9dvm44w4nysqprrhs553in19jwwkf7kryp";
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
