{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerApp rec {
  pname = "gemstash";
  gemdir = ./.;
  exes = [ pname ];

  passthru = {
    updateScript = bundlerUpdateScript pname;
    tests = { inherit (nixosTests) gemstash; };
  };

  meta = {
    description = "Cache for RubyGems.org and a private gem server";
    homepage = "https://github.com/rubygems/gemstash";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.viraptor ];
  };
}
