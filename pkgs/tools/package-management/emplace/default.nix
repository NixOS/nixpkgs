{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h1z18m504kflzv9wcybkgc4xr5w9l9d7qsjri0an57lxv6dpv0f";
  };

  cargoSha256 = "1wfxy4py2xwf1m0i52jq1f9xgzc7v5m55crl0xbp8f0raflksaxk";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
  };
}
