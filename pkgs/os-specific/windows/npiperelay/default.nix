{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "npiperelay";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jstarks";
    repo = "npiperelay";
    rev = "v${version}";
    sha256 = "sha256-cg4aZmpTysc8m1euxIO2XPv8OMnBk1DwhFcuIFHF/1o=";
  };

  vendorSha256 = null;

  meta = {
    description = "Access Windows named pipes from WSL";
    homepage = "https://github.com/jstarks/npiperelay";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.shlevy ];
    platforms = lib.platforms.windows;
  };
}
