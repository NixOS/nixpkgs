{
  lib,
  bundlerEnv,
  bundlerUpdateScript,
  ruby,
}:

bundlerEnv {
  pname = "license_finder";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "license_finder";

  meta = {
    description = "Find licenses for your project's dependencies";
    homepage = "https://github.com/pivotal/licensefinder";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
