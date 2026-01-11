{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "ceedling";
  gemdir = ./.;
  exes = [ "ceedling" ];

  meta = {
    description = "Build system for C projects that is something of an extension around Ruby's Rake";
    homepage = "https://www.throwtheswitch.org/ceedling";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.rlwrnc ];
    mainProgram = "ceedling";
  };
}
