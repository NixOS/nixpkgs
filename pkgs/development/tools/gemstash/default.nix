{
  lib,
  bundlerApp,
  bundlerUpdateScript,
  nixosTests,
}:

bundlerApp {
  pname = "gemstash";
  gemdir = ./.;
  exes = [ "gemstash" ];

  passthru = {
    updateScript = bundlerUpdateScript "gemstash";
    tests = { inherit (nixosTests) gemstash; };
  };

  meta = with lib; {
    description = "Cache for RubyGems.org and a private gem server";
    homepage = "https://github.com/rubygems/gemstash";
    license = licenses.mit;
    maintainers = [ maintainers.viraptor ];
  };
}
