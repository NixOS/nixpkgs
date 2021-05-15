{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv {
  pname = "rubocop";

  inherit ruby;

  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "rubocop";

  meta = with lib; {
    description = "Automatic Ruby code style checking tool";
    homepage = "https://rubocop.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam leemachin ];
  };
}
