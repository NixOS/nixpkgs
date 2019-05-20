{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  pname = "rubocop";

  inherit ruby;

  gemdir = ./.;

  meta = with lib; {
    description = "Automatic Ruby code style checking tool";
    homepage = "https://docs.rubocop.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ leemachin ];
    platforms = platforms.unix;
  };
}
