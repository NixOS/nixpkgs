{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "licensee";
  gemdir = ./.;
  exes = [ "licensee" ];

  passthru.updateScript = bundlerUpdateScript "licensee";

  meta = {
    description = "Ruby Gem to detect under what license a project is distributed";
    homepage = "https://licensee.github.io/licensee/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.unix;
    mainProgram = "licensee";
  };
}
