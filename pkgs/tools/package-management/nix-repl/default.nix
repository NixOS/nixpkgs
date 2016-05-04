{ lib, stdenv, fetchFromGitHub, nix, readline, boehmgc }:

let rev = "8a2f5f0607540ffe56b56d52db544373e1efb980"; in

stdenv.mkDerivation {
  name = "nix-repl-${lib.getVersion nix}-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-repl";
    inherit rev;
    sha256 = "0cjablz01i0g9smnavhf86imwx1f9mnh5flax75i615ml71gsr88";
  };

  buildInputs = [ nix readline ];

  dontBuild = true;

  # FIXME: unfortunate cut&paste.
  installPhase = ''
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
