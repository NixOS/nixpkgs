{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "uefi-run";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Richard-W";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OL21C3J4M7q1nNB6lL9xaU6ryZN45UDUqiKsbqQhYH8=";
  };

  cargoSha256 = "sha256-ieX8jQKv9Fht1p7JtTieZ5M+rXdn6/Oo/LgJ8NEBIuQ=";

  meta = with lib; {
    description = "Directly run UEFI applications in qemu";
    homepage = "https://github.com/Richard-W/uefi-run";
    license = licenses.mit;
    maintainers = [ maintainers.maddiethecafebabe ];
  };
}
