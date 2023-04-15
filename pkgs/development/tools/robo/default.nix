{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "robo";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "consolidation";
    repo = "robo";
    rev = finalAttrs.version;
    hash = "sha256-4sQc3ec34F5eBy9hquTqmzUgvFCTlml3LJdP39gPim4=";
  };

  vendorHash = "sha256-cbXpluxBGSFatDmoblL57UMG1+g7SrmEXVMA4iaYfkY=";

  meta = with lib; {
    description = "Modern task runner for PHP";
    license = licenses.mit;
    homepage = "https://github.com/consolidation/robo";
    maintainers = teams.php.members;
  };
})
