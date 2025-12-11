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
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = lib.platforms.unix;
    mainProgram = "haste";
  };
}
