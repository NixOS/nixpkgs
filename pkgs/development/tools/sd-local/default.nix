{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "sd-local";
  version = "1.0.49";

  src = fetchFromGitHub {
    owner = "screwdriver-cd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cyu2J7clIyM6j9ELO2Xk/9agQHtvPtr9yHM/gRTzzG0=";
  };

  vendorHash = "sha256-uHu8jPPQCJAhXE+Lzw5/9wyw7sL5REQJsPsYII+Nusc=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "screwdriver.cd local mode";
    homepage = "https://github.com/screwdriver-cd/sd-local";
    license = licenses.bsd3;
    maintainers = with maintainers; [ midchildan ];
  };
}
