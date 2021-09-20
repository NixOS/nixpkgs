{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "tv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "uzimaru0000";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4PcD0keG3OVZPv6MA+rNSL9lysrseJUA6C5cd2f6LRY=";
  };

  cargoSha256 = "sha256-E4qMxCqgJYIA8E6A0d8iUYTbKif5T51zcFdc+Ptq7qc=";

  meta = with lib; {
    description = "Format json into table view";
    homepage = "https://github.com/uzimaru0000/tv";
    changelog = "https://github.com/uzimaru0000/tv/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
