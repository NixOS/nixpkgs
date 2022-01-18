{ lib, fetchFromGitHub, rustPlatform, cmake }:
rustPlatform.buildRustPackage rec {
  pname = "unused";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "unused-code";
    repo = pname;
    rev = version;
    sha256 = "sha256-1R50oCVvk+XJG4EhLusY1aY6RjWNeZvlIDS8PJXIA7o=";
  };

  nativeBuildInputs = [ cmake ];

  cargoSha256 = "sha256-PjCR+kHlgPWkTkhN0idotGmLSe/FaKkgI9AMEJtoRz8=";

  meta = with lib; {
    description = "A tool to identify potentially unused code";
    homepage = "https://unused.codes";
    license = licenses.mit;
    maintainers = [ maintainers.lrworth ];
  };
}
