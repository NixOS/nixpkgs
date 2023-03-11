{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MvtMgdlMVMp2qWN+EbAKZwBwW0TA8aivlJY8KZm+7jM=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-vxfoJnyG0wWgkcZpQYiKkQaHl01VDuQ0kA26MXVCgY8=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
