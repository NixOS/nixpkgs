{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y01hi3jpfawqlqs8ka0vwfhjw5j5gkhk2nz5m13ns2h27bw20v7";
  };

  cargoSha256 = "0l1kavacnjvi22l6pawgkqqxnjaizi3pddqkhwjshw4pzzixzvli";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
