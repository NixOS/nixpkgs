{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "lovelace-card-mod";
<<<<<<< HEAD
  version = "4.1.0";
=======
  version = "4.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-card-mod";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-w2ky3jSHRbIaTzl0b0aJq4pzuCNUV8GqYsI2U/eoGfs=";
  };

  npmDepsHash = "sha256-7VoPQGUQLuQYaB3xAbvv0Ux7kiE/usnIxX2+jYGQXqA=";
=======
    hash = "sha256-BXyNXxCSEY0/AUD+6ggTvXPyPQYnAjkEgAVFmui6FAs=";
  };

  npmDepsHash = "sha256-afIJbUNKKCWckL60cpj4V2SMCOX0Kn56AkVK9t923D0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp card-mod.js $out

    runHook postInstall
  '';

  passthru.entrypoint = "card-mod.js";

<<<<<<< HEAD
  meta = {
    description = "Add CSS styles to (almost) any lovelace card";
    homepage = "https://github.com/thomasloven/lovelace-card-mod";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Add CSS styles to (almost) any lovelace card";
    homepage = "https://github.com/thomasloven/lovelace-card-mod";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
