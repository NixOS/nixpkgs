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

  meta = with lib; {
    description = "A cache for RubyGems.org and a private gem server";
    homepage = "https://github.com/rubygems/gemstash";
    license = licenses.mit;
    maintainers = [ maintainers.viraptor ];
  };
}
