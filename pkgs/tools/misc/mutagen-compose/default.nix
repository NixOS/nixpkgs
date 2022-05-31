{ stdenv, lib, buildGo118Module, fetchFromGitHub, fetchzip }:

buildGo118Module rec {
  pname = "mutagen-compose";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FNV4X9/BdnfFGKVJXNpCJLdr3Y29LrGi+zUuQ07xUbE=";
  };

  vendorSha256 = "sha256-5nt9YHMgaRpkFdOnBTU4gSdOtB3h9Cj5CCUjx9PJ/m8=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
