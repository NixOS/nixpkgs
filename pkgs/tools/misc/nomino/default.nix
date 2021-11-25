{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    sha256 = "1nnyz4gkwrc2zccw0ir5kvmiyyv3r0vxys9r7j4cf0ymngal5kwp";
  };

  cargoSha256 = "0501w3124vkipb1rnksjaizkghw3jf3nmmmmf3zprmcaim1b4szg";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
