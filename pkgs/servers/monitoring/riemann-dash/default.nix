{ bundlerApp, lib, bundlerUpdateScript }:

bundlerApp {
  pname = "riemann-dash";
  gemdir = ./.;
  exes = [ "riemann-dash" ];

  passthru.updateScript = bundlerUpdateScript "riemann-dash";

  meta = with lib; {
    description = "Javascript, websockets-powered dashboard for Riemann";
    homepage = "https://github.com/riemann/riemann-dash";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms = platforms.unix;
  };
}
