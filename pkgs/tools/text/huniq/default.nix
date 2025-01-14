{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "huniq";
  version = "2.7.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-5GvHM05qY/Jj1mPYwn88Zybn6Nn5nJIaw0XP8iCcrwE=";
  };

  cargoSha256 = "sha256-pwDaLHJbVpZe7dAtd5/ytyHZkUHjCcNjtw3q7HF1qVQ=";

  meta = with lib; {
    description = "Command line utility to remove duplicates from the given input";
    homepage = "https://github.com/koraa/huniq";
    license = licenses.bsd3;
    maintainers = with maintainers; [ figsoda ];
  };
}
