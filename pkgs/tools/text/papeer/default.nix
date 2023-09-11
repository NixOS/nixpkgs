{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "papeer";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Kdy660FuPjXYF/uqndljmIvA6r+lo3D86W9pK6KqXl0=";
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
