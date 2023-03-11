{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rLnGi6s5vNBxBRcim5cvLm5ajclK1q4mfgLCJ/sT1nU=";
  };

  cargoHash = "sha256-q3xSngar5/+5pFdiB//spiYQuXiNuRHSWOF6UPzccIU=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
