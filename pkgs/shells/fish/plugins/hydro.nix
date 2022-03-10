{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "hydro";
  version = "d4875065ceea226f58ead97dd9b2417937344d6e";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "hydro";
    rev = version;
    sha256 = "sha256-nXeDnqqOuZyrqGTPEQtYlFvrFvy1bZVMF4CA37b0lsE=";
  };

  meta = with lib; {
    description = "Ultra-pure, lag-free prompt with async Git status.";
    homepage = "https://github.com/jorgebucaran/hydro`";
    license = licenses.mit;
    maintainers = with maintainers; [ mrhedgehog ];
  };
}
