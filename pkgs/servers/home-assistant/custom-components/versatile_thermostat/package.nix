{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  gitUpdater,
}:

buildHomeAssistantComponent rec {
  owner = "jmcollin78";
  domain = "versatile_thermostat";
<<<<<<< HEAD
  version = "8.3.2";
=======
  version = "7.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-kHDLFxhrGTCpqkTvvjbplYSqXbrmN9KPhQuszTtoGQc=";
=======
    hash = "sha256-QE3XTummNZCziZPKfFjTI0ell+bftGqbcG0hh+QHx9s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.updateScript = gitUpdater { ignoredVersions = "(Alpha|Beta|alpha|beta).*"; };

  meta = {
    changelog = "https://github.com/jmcollin78/versatile_thermostat/releases/tag/${version}";
    description = "Full-featured thermostat";
    homepage = "https://github.com/jmcollin78/versatile_thermostat";
    maintainers = with lib.maintainers; [ pwoelfel ];
    license = lib.licenses.mit;
  };
}
