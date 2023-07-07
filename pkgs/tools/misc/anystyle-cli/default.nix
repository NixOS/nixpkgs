{ lib
, buildRubyGem
, bundlerEnv
, ruby
, poppler_utils
}:
let
  deps = bundlerEnv rec {
    name = "anystyle-cli-${version}";
    source.sha256 = lib.fakeSha256;
    version = "1.3.1";
    inherit ruby;
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) {
      anystyle.source = {
        remotes = ["https://rubygems.org"];
        sha256 = "1w79zcia60nnnyrmyvpd10pmxrpk5c7lj9gmmblhwi8x5mfq9k0n";
        type = "gem";
      };
    };
  };
in
buildRubyGem rec {
  inherit ruby;
  gemName = "anystyle-cli";
  pname = gemName;
  version = "1.3.1";
  source.sha256 = "1a3ifwxwqkp5dnfk9r8qq8kgfb8k1pl7jjdghbb8ixbxz9ac7awy";

  propagatedBuildInputs = [ deps ];

  preFixup = ''
    wrapProgram $out/bin/anystyle --prefix PATH : ${poppler_utils}/bin
  '';

  meta = with lib; {
    description = "Command line interface to the AnyStyle Parser and Finder";
    homepage    = "https://anystyle.io/";
    license     = licenses.bsd2;
    maintainers = with maintainers; [ shamilton ];
    mainProgram = "anystyle";
    platforms   = platforms.unix;
  };
}
