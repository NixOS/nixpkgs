{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "haste";
  gemdir = ./.;
  exes = [ "haste" ];

  meta = {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://rubygems.org/gems/haste";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "haste";
  };
}
