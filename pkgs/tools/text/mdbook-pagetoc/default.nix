{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yFgzgppGX3moLt7X4Xa6Cqs7v5OYJMjXKTV0sqRFL3o=";
  };

  cargoHash = "sha256-U5KNkUXqCU3cVYOqap19aYpaTyY91kGaGxcW8oxsUxI=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
