{ stdenv, lib, bundlerApp}:

bundlerApp rec {
  pname = "github_changelog_generator";
  gemdir = ./.;
  exes = [ "github_changelog_generator" ];

  meta = with lib; {
    description = "Fully automated changelog generation - This gem generates a changelog file based on tags, issues and merged pull requests";
    homepage    = https://github.com/github-changelog-generator/github-changelog-generator;
    license     = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
    platforms   = platforms.unix;
  };
}
