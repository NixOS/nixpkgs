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
    homepage = "http://www.throwtheswitch.org/ceedling";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
