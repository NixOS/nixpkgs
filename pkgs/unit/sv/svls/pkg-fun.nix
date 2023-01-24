{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-1qYTYAXNMM3umRFpWoij8VU3rhBI4QWePa5Uaz2Y4Ik=";
  };

  cargoSha256 = "sha256-il7n8uxeXPKCBpRv3rqZZzqWjfpy558YNKBs9qOJ2oI=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
