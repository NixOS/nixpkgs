{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tv";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "uzimaru0000";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mh/+MX0MZM1fsi9HGTioRRH1DVatmkdyiwAgG/42cVU=";
  };

  cargoSha256 = "sha256-8uxW0EIeMPvgffYW55Ov1euoVi8Zz9fZ4F44ktxvj9Q=";

  meta = with lib; {
    description = "Format json into table view";
    homepage = "https://github.com/uzimaru0000/tv";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
