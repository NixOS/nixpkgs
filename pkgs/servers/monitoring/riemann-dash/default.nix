{ bundlerEnv, lib, ruby }:

bundlerEnv {
  inherit ruby;
  pname = "riemann-dash";
  gemdir = ./.;

  meta = with lib; {
    description = "A javascript, websockets-powered dashboard for Riemann";
    homepage = https://github.com/riemann/riemann-dash;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
