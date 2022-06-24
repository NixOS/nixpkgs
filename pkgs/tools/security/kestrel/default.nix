{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "kestrel";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "finfet";
    repo = "kestrel";
    rev = "v${version}";
    sha256 = "MZ/FmRi8Dairmr+TdrfjbGAKMQuQJYtKfb8UIAtNRos=";
  };

  cargoSha256 = "sha256-Hda7deOubywQuxz7kGtK0fDEN60UhYI/pFLqU/l2VPs=";

  meta = with lib; {
    description = "A data-at-rest file encryption program that lets you encrypt files to anyone with a public key";
    homepage = "https://getkestrel.com";
    license = licenses.bsd3;
    maintainers = [ maintainers.sersorrel ];
  };
}
