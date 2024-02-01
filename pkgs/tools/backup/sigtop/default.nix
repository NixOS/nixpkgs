{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "sigtop";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-vFs6/b2ypwMXDgmkZDgfKPqW0GRh9A2t4QQvkUdhYQw=";
  };

  vendorHash = "sha256-H43XOupVicLpYfkWNjArpSxQWcFqh9h2Zb6zGZ5xtfs=";

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
