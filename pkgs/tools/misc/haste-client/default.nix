{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "haste";
  gemdir = ./.;
  exes = [ "haste" ];

  meta = with lib; {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage = "https://rubygems.org/gems/haste";
    license = licenses.mit;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.unix;
    mainProgram = "haste";
  };
}
