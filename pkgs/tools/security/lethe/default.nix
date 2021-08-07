{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lethe";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "kostassoid";
    repo = pname;
    rev = "v${version}";
    sha256 = "173ms4fd09iclm4v5zkmvc60l6iyyb5lzxc6dxd6q21zy0pvs35g";
  };

  cargoSha256 = "11l7wxadinidf0bsxv14j1kv8gdhq1d6ffnb76n54igxid8gza14";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Tool to wipe drives in a secure way";
    homepage = "https://github.com/kostassoid/lethe";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
