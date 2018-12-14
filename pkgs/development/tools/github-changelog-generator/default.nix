{ stdenv, lib, bundlerEnv, ruby, fetchFromGitHub,  makeWrapper}:
let
  env = bundlerEnv {
    inherit ruby;
    name = "github-changelog-generator-env";
    gemdir = ./.;
  };
in stdenv.mkDerivation rec {
  name = "github-changelog-generator-${version}";
  version = "v1.14.3";

  src = fetchFromGitHub {
    owner = "github-changelog-generator";
    repo = "github-changelog-generator";
    rev = version; # Always use a commit id here!
    sha256 = "0bmv5z8cjj9mhmmjy54nhfwkszhxx4zbi8x1h0yx219fxihi00pd";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -R lib/* $out/lib/
    cp -R bin/* $out/bin/
    chmod +x bin/*
    makeWrapper $out/bin/git-generate-changelog $out/bin/git-generate-changelog-wrapped --prefix PATH : ${lib.makeBinPath [ ruby ]}
    makeWrapper $out/bin/github_changelog_generator $out/bin/github_changelog_generator-wrapped --prefix PATH : ${lib.makeBinPath [ ruby ]}
  '';

  meta = with lib; {
    description = "Fully automated changelog generation - This gem generates a changelog file based on tags, issues and merged pull requests";
    homepage    = https://github.com/github-changelog-generator/github-changelog-generator;
    license     = licenses.mit;
    maintainers = with maintainers; [ scriptkiddi ];
    platforms   = platforms.unix;
  };
}
