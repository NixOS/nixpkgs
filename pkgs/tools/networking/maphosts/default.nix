{ stdenv, lib, bundlerEnv, ruby }:

stdenv.mkDerivation rec {
  name = "maphosts-${env.gems.maphosts.version}";

  env = bundlerEnv {
    name = "maphosts-gems";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "${env}/bin/maphosts" "$out/bin/maphosts"
  '';

  meta = with lib; {
    description = "Small command line application for keeping your project hostnames in sync with /etc/hosts";
    homepage    = https://github.com/mpscholten/maphosts;
    license     = licenses.mit;
    maintainers = with maintainers; [ mpscholten ];
    platforms   = platforms.all;
  };
}
