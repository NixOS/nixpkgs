{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QCoH8N6HDpXQXWchccGIG/pbDx9qZ8YKM6VP6lxoYzU=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-F51BHBUaQx1xg0Y2eVnXGRCMykbzk3q5IyJ528JyA5o=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
