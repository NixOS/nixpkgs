{ stdenv, bundlerEnv, ruby, bundlerUpdateScript }:

let
  papertrail-env = bundlerEnv {
    name = "papertrail-env";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in stdenv.mkDerivation {
  name = "papertrail-${(import ./gemset.nix).papertrail.version}";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${papertrail-env}/bin/papertrail $out/bin/papertrail
  '';

  passthru.updateScript = bundlerUpdateScript "papertrail";

  meta = with stdenv.lib; {
    description = "Command-line client for Papertrail log management service";
    homepage    = http://github.com/papertrail/papertrail-cli/;
    license     = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    platforms   = ruby.meta.platforms;
  };
}
