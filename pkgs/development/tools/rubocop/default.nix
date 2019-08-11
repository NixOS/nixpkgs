{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv rec {
  pname = "rubocop";

  inherit ruby;

  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "rubocop";

  meta = with lib; {
    description = "Automatic Ruby code style checking tool";
    homepage = "https://docs.rubocop.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam leemachin ];
    platforms = platforms.unix;
  };
}
