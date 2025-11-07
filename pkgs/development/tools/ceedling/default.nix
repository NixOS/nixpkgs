{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "ceedling";
  gemdir = ./.;
  exes = [ "ceedling" ];

  meta = with lib; {
    description = "Build system for C projects that is something of an extension around Ruby's Rake";
    homepage = "https://www.throwtheswitch.org/ceedling";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.rlwrnc ];
    mainProgram = "ceedling";
  };
}
