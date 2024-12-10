{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "papeer";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nEt2rxI9slrEkbpMpXQM6+jO0QWQsuLdOswXPCSozJs=";
  };

  vendorHash = "sha256-3QRSdkx9p0H+zPB//bpWCBKKjKjrx0lHMk5lFm+U7pA=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
