{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cliphist";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V115xsdSAsxp1RQpCVoGqkkb8J6Rvj5NNNtPMwT9IAg=";
  };

  vendorHash = "sha256-/xu1kcSOBOVz7XNxe4Jl905HtFWFOaZHKkLNFaLMVEs=";

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
  };
}
