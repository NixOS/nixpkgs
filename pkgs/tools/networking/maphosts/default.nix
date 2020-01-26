{ stdenv, lib, bundlerEnv, ruby, bundlerUpdateScript }:

let
  env = bundlerEnv {
    name = "maphosts-gems";
    inherit ruby;
    gemdir = ./.;
  };
in stdenv.mkDerivation {
  name = "maphosts-${env.gems.maphosts.version}";

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
