{ lib, stdenv, bundlerEnv, ruby, bundlerUpdateScript }:

stdenv.mkDerivation rec {
  pname = "watson-ruby";
  version = (import ./gemset.nix).watson-ruby.version;

  dontUnpack = true;

  installPhase = let
    env = bundlerEnv {
      name = "watson-ruby-gems-${version}";
      inherit ruby;
      # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
      gemdir = ./.;
    };
  in ''
    mkdir -p $out/bin
    ln -s ${env}/bin/watson $out/bin/watson
  '';

  passthru.updateScript = bundlerUpdateScript "watson-ruby";

  meta = with lib; {
    description = "An inline issue manager";
    homepage    = "https://goosecode.com/watson/";
    license     = with licenses; mit;
    maintainers = with maintainers; [ robertodr nicknovitski ];
    mainProgram = "watson";
    platforms   = platforms.unix;
  };
}
