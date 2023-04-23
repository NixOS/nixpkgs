{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-e/cJ1kVFUs2chOpqu2tHsK9MBhlMx9u6mIa5uUwvVg8=";
  };

  vendorHash = "sha256-hCdIO377LiXFKz0GfCmAADTPfoatk8YWzki7lVP3yLw=";

  meta = with lib; {
    homepage = "https://xcfile.dev/";
    description = "Markdown defined task runner";
    license = licenses.mit;
    maintainers = with maintainers; [ joerdav ];
  };
}
