{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "hydro";
  version = "unstable-2024-03-24";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "hydro";
    rev = "bc31a5ebc687afbfb13f599c9d1cc105040437e1";
    hash = "sha256-0MMiM0NRbjZPJLAMDXb+Frgm+du80XpAviPqkwoHjDA=";
  };

  meta = with lib; {
    description = "Ultra-pure, lag-free prompt with async Git status";
    homepage = "https://github.com/jorgebucaran/hydro";
    license = licenses.mit;
    maintainers = with maintainers; [ pyrox0 ];
  };
}
