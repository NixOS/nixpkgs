{ stdenv, lib, bundlerEnv, ruby, bundlerUpdateScript }:

stdenv.mkDerivation rec {
  name = "maphosts-${env.gems.maphosts.version}";

  env = bundlerEnv {
    name = "maphosts-gems";
    inherit ruby;
    gemdir = ./.;
  };

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "${env}/bin/maphosts" "$out/bin/maphosts"
  '';

  passthru.updateScript = bundlerUpdateScript "maphosts";

  meta = with lib; {
    description = "Small command line application for keeping your project hostnames in sync with /etc/hosts";
    homepage    = https://github.com/mpscholten/maphosts;
    license     = licenses.mit;
    maintainers = with maintainers; [ mpscholten nicknovitski ];
    platforms   = platforms.all;
  };
}
