{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "autopair";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "autopair.fish";
    rev = version;
    sha256 = "sha256-s1o188TlwpUQEN3X5MxUlD/2CFCpEkWu83U9O+wg3VU=";
  };

  meta = {
    description = "Auto-complete matching pairs in the Fish command line";
    homepage = "https://github.com/jorgebucaran/autopair.fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      figsoda
      kidonng
    ];
  };
}
