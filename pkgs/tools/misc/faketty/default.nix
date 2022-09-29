{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "faketty";
  version = "1.0.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Jljq22xbXakwKdf5TXBXzuKuKJOBjf6lzCy8aHrVC3U=";
  };

  cargoSha256 = "sha256-K0hNnqw178b7noHW76DMR0BoYhkrQpPQeHaH6Azt3Xo=";

  postPatch = ''
    patchShebangs tests/test.sh
  '';

  meta = with lib; {
    description = "A wrapper to execute a command in a pty, even if redirecting the output";
    homepage = "https://github.com/dtolnay/faketty";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
