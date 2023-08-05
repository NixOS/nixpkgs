{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "papeer";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oXhAiw2oYefmF+a8DqjP2f3AY0+WZ1ZdiNG9bEhSQ84=";
  };

  vendorHash = "sha256-3QRSdkx9p0H+zPB//bpWCBKKjKjrx0lHMk5lFm+U7pA=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
