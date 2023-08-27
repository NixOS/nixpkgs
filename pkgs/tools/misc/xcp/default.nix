{ rustPlatform, fetchFromGitHub, lib }:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XFLkz6beTSto+iFjqKCLyXssXL+OccM3MNI4ldgbsqI=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-Bf9OjViNuE6keCmDQDlqSVterKdcgWaH031CyzviApA=";

  meta = with lib; {
    description = "An extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
  };
}
