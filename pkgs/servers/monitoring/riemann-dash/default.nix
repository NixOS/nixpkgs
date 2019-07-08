{ bundlerApp, lib }:

bundlerApp {
  pname = "riemann-dash";
  gemdir = ./.;
  exes = [ "riemann-dash" ];

  meta = with lib; {
    description = "A javascript, websockets-powered dashboard for Riemann";
    homepage = https://github.com/riemann/riemann-dash;
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.unix;
  };
}
