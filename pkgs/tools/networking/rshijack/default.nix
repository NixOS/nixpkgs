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

  cargoSha256 = "1rbp94wxr8kqjfg35hf44vn3qa0f0jcq8i50a8d0g5y2qf12h04d";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
  };
}
