{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "dua";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "dua-cli";
    rev = "v${version}";
    sha256 = "0xiprpk74l0q5w3j82lx1l3jy4mi015nvlixih9z1lam4qi1yq0p";
  };

  cargoSha256 = "1jg1ljm5h21shkyfrq0ivz9m0c25dxc0kd6cipf5i2dbnzcszmhh";

  meta = with lib; {
    description = "A tool to conveniently learn about the disk usage of directories, fast!";
    homepage = "https://github.com/Byron/dua-cli";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ killercup ];
    platforms = platforms.all;
  };
}
