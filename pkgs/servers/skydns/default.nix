{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "skydns";
  version = "unstable-2019-10-15";

  src = fetchFromGitHub {
    owner = "skynetservices";
    repo = "skydns";
    rev = "94b2ea0d8bfa43395656ea94d4a6235bdda47129";
    hash = "sha256-OWLJmGx21UoWwrm6YNbPYdj3OgEZz7C+xccnkMOZ71g=";
  };

  vendorHash = "sha256-J3+DACU9JuazGCZZrfKxHukG5M+nb+WbV3eTG8EaT/w=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/skynetservices/skydns/commit/37be34cd64a3037a6d5a3b3dbb673f391e9d7eb1.patch";
      hash = "sha256-JziYREg3vw8NMIPd8Zv8An7XUj+U6dvgRcaZph0DLPg=";
    })
  ];

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A distributed service for announcement and discovery of services";
    homepage = "https://github.com/skynetservices/skydns";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "skydns";
  };
}
