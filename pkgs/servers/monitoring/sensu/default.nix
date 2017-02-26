{ lib, bundlerEnv, ruby }:

bundlerEnv {
  name = "sensu-${version}";
  version = (import gemset).sensu.version;

  inherit ruby;
  gemdir = ./.;

  meta = with lib; {
    description = "A monitoring framework that aims to be simple, malleable, and scalable";
    homepage    = http://sensuapp.org/;
    license     = licenses.mit;
    maintainers = with maintainers; [ theuni peterhoeg ];
    platforms   = platforms.unix;
  };
}
