{ stdenv, bundlerEnv, ruby }:


stdenv.mkDerivation rec {
  name = "watson-ruby-${version}";
  version = (import ./gemset.nix).watson-ruby.version;

  env = bundlerEnv rec {
    name = "watson-ruby-gems-${version}";
    inherit ruby;
    # expects Gemfile, Gemfile.lock and gemset.nix in the same directory
    gemdir = ./.;
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${env}/bin/watson $out/bin/watson
  '';

  meta = with stdenv.lib; {
    description = "An inline issue manager";
    homepage    = http://goosecode.com/watson/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ robertodr ];
    platforms   = platforms.unix;
  };
}
