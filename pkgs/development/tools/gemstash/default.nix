{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp rec {
  pname = "gemstash";
  gemdir = ./.;
  exes = [ pname ];

  passthru.updateScript = bundlerUpdateScript pname;

  meta = with lib; {
    description = "A cache for RubyGems.org and a private gem server";
    homepage    = "https://github.com/rubygems/gemstash";
    license     = licenses.mit;
    maintainers = [ maintainers.viraptor ];
  };
}
