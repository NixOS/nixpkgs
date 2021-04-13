{ lib
, pkg-config
, python38
, openssl
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "PyOxidizer";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "indygreg";
    repo = pname;
    rev = "v${version}";
    sha256 = "07hd00nyg1mbjlg8241ci5w6clqchcrlmld2vy4nca26j5b4k46k";
  };

  cargoSha256 = "14k81n56w29fdwm1bwbsmb3p7nawjbvfrqg2p74a0bz33hq5iby3";
  depsBuildBuild = [ openssl pkg-config python38 ];
  doCheck = false;

  meta = with lib; {
    description = "A utility for producing binaries that embed Python";
    homepage = "https://github.com/indygreg/PyOxidizer";
    license = licenses.mpl20;
    maintainer = with maintainers; [ matthiasbeyer ];
  };
}
