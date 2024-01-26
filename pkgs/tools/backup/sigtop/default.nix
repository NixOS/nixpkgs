{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "sigtop";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-goGvgn1QyWqipcrBvO27BjzFbp7cIPFWzWJaOpp2/1Q=";
  };

  vendorHash = "sha256-K33VZeyOFoLLo64FuYt9bxJvaESSlHEy/2O8kLxxL5U=";

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = with lib; {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fricklerhandwerk ];
  };
}
