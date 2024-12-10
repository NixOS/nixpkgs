{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "sqlint";
  gemdir = ./.;

  exes = [ "sqlint" ];

  passthru.updateScript = bundlerUpdateScript "sqlint";

  meta = with lib; {
    description = "Simple SQL linter";
    homepage = "https://github.com/purcell/sqlint";
    license = licenses.mit;
    maintainers = with maintainers; [
      ariutta
      nicknovitski
      purcell
    ];
    platforms = platforms.unix;
  };
}
