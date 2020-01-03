{ stdenv, bundlerEnv, ruby, bundlerUpdateScript }:

stdenv.mkDerivation rec {
  pname = "watson-ruby";
  version = (import ./gemset.nix).watson-ruby.version;

  phases = [ "installPhase" ];

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

  meta = with stdenv.lib; {
    description = "An inline issue manager";
    homepage    = http://goosecode.com/watson/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ robertodr nicknovitski ];
    platforms   = platforms.unix;
  };
}
