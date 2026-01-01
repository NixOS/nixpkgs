{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin {
  pname = "hydro";
  version = "0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "hydro";
    rev = "9c93b89573bd722f766f2190a862ae55e728f6ba";
    hash = "sha256-QYq4sU41/iKvDUczWLYRGqDQpVASF/+6brJJ8IxypjE=";
  };

<<<<<<< HEAD
  meta = {
    description = "Ultra-pure, lag-free prompt with async Git status";
    homepage = "https://github.com/jorgebucaran/hydro";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Ultra-pure, lag-free prompt with async Git status";
    homepage = "https://github.com/jorgebucaran/hydro";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
