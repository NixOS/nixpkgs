{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "svlint";
  version = "0.4.18";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "svlint";
    rev = "v${version}";
    sha256 = "sha256-p002oWwTQxesWLgLq8oKKzuZKXUdO4C1TZ7lR/Mh1PA=";
  };

  cargoSha256 = "sha256-1WEPJpU/hLn+qjU+ETkmbfZIJTORe3OUdyl605JnYmU=";

  meta = with lib; {
    description = "SystemVerilog linter";
    homepage = "https://github.com/dalance/svlint";
    license = licenses.mit;
    maintainers = with maintainers; [ trepetti ];
  };
}
