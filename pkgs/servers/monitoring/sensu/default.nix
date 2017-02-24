  { lib, bundlerEnv, ruby }:

  bundlerEnv {
    name = "sensu-0.17.1";

    inherit ruby;
    gemdir = ./.;

    meta = with lib; {
      description = "A monitoring framework that aims to be simple, malleable, and scalable";
      homepage    = http://sensuapp.org/;
      license     = licenses.mit;
      maintainers = with maintainers; [ theuni ];
      platforms   = platforms.unix;
    };
  }
