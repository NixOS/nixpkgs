{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sync-readme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "phaazon";
    repo = pname;
    rev = version;
    sha256 = "1c38q87fyfmj6nlwdpavb1xxpi26ncywkgqcwbvblad15c6ydcyc";
  };

  cargoSha256 = "0vrbgs49ghhl4z4ljhghcs9fnbf7qx1an9kwbrgv9wng8m1dccah";

  meta = with lib; {
    description = "A cargo plugin that generates a Markdown section in your README based on your Rust documentation";
    homepage = "https://github.com/phaazon/cargo-sync-readme";
    license = licenses.bsd3;
    maintainers = with maintainers; [ b4dm4n ];
  };
}
