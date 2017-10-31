{ lib, stdenv, fetchFromGitHub, nix, readline, boehmgc }:

let rev = "a1ea85e92b067a0a42354a28355c633eac7be65c"; in

stdenv.mkDerivation {
  name = "nix-repl-${lib.getVersion nix}-2016-02-28";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-repl";
    inherit rev;
    sha256 = "0rf9711day64lgg6g6yqc5709x4sgj137zpqyn019k764i7m2xs8";
  };

  buildInputs = [ nix readline ];

  dontBuild = true;

  # FIXME: unfortunate cut&paste.
  installPhase = ''
    mkdir -p $out/bin
    $CXX -O3 -Wall -std=c++0x \
      -o $out/bin/nix-repl nix-repl.cc \
      -I${nix.dev}/include/nix \
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
