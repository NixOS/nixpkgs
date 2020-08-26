{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "15d21qv8cbzwpz2gsq1cgvxdbqm45zq2wfphhjqq77z1kay43m3f";
  };

  cargoSha256 = "0xd1b0rfrf3a6j0xkyfqz2pd0lkb6dpqyyghli9a8kh0kdfxvndj";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
