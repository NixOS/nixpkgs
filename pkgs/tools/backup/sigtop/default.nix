{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "sigtop";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-U+S+VXRkedq2LkO9Fw/AfNS97GvFEfjD8dq/VMlBOv4=";
  };

  vendorHash = "sha256-xrJ/KLM/f/HVPL4MJzRc1xDlO4e+Iu2lcPG4GnjFRBo=";

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = with lib; {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    license = licenses.isc;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ fricklerhandwerk ];
  };
}
