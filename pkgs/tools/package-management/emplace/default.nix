{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s04hi0i1ssg9dp75f9qdglnvqmh0cxmbk8nnhd4w45v9m5sadph";
  };

  cargoSha256 = "10y7lpgj9mxrh3rmc15km4rfzspwdjr8dcdh0747rjn6dcpfhcdq";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
