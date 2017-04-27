{ stdenv, fetchFromGitHub, nix }:

stdenv.mkDerivation rec {
  name = "nix-upgrade-scripts-${version}";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner  = "peterhoeg";
    repo   = "nix-upgrade-scripts";
    rev    = "v${version}";
    sha256 = "13v91nniwrs1fr92msrq6sq7vy1whrlxqd1ll4q3p1nrnbzpnxkn";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin lib $out/
    for f in $out/bin/* ; do
      substituteInPlace $f \
        --replace '/usr/bin/env nix-shell' ${nix}/bin/nix-shell
    done
    chmod +x $out/bin/*
  '';

  meta = with stdenv.lib; {
    description = "Scripts for making package upgrades easier";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
