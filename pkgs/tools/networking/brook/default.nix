{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "brook";
  version = "20240404";

  src = fetchFromGitHub {
    owner = "txthinking";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QqA0LnbC72bnAQ25AehTnoXgdqQPc8wztHcFd4Q19ko=";
  };

  vendorHash = "sha256-1aaOPeKHPrZO6WK08EhX4+dME0A33raQnbZi/aNFpIw=";

  meta = with lib; {
    homepage = "https://github.com/txthinking/brook";
    description = "A cross-platform Proxy/VPN software";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "brook";
  };
}
