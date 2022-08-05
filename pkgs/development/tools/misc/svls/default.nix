{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svls";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svls";
    rev = "v${version}";
    sha256 = "sha256-m7xV5sQZnRytT3QY1a9qihZV0Ub6zKjfDytZ+TDwdFg=";
  };

  cargoSha256 = "sha256-993XWYSUC2KuV2/dgTYAatoy5lGIveT3lL7eOYsbCig=";

  meta = with lib; {
    description = "SystemVerilog language server";
    homepage = "https://github.com/dalance/svls";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
