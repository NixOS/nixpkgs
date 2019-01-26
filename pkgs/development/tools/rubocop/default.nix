{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  pname = "rubocop";

  inherit ruby;

  gemdir = ./.;

  meta = with lib; {
    description = "Automatic Ruby code style checking tool";
    homepage = http://rubocop.readthedocs.io/en/latest/;
    license = licenses.mit;
    maintainers = with maintainers; [ leemachin ];
    platforms = platforms.unix;
  };
}
