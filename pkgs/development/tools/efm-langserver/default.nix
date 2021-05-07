{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "efm-langserver";
  version = "0.0.31";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "efm-langserver";
    rev = "v${version}";
    sha256 = "sha256-4NdD+WwvlqfJdPqXTz9LUyriJyLPppi8jH6dxYupe6A=";
  };

  vendorSha256 = "sha256-tca+1SRrFyvU8ttHmfMFiGXd1A8rQSEWm1Mc2qp0EfI=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "General purpose Language Server";
    maintainers = with maintainers; [ Philipp-M ];
    homepage = "https://github.com/mattn/efm-langserver";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
