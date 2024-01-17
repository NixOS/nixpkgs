{ lib
, linux-pam
, rustPlatform
, fetchFromGitHub
, buildFeatures ? [ "gnu" ]
}:

rustPlatform.buildRustPackage rec {
  pname = "unFTP";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "bolcom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-CPq4CH7reS5AI145l8U1nekm2MKnmoBfVqENR9QOKF4";
  };

  #Extra cargo Build Features
  inherit buildFeatures;

  buildInputs = [
    linux-pam
  ];

  cargoSha256 = "sha256-vFu1D2GYItVGeTmd/rwmZHM/mf4zQ3tzBLux7vb+yZ0=";

  meta = with lib; {
    description = "A FTP(S) server with a couple of twists written in Rust";
    homepage = "https://unftp.rs";
    license = licenses.asl20;
    maintainers = with maintainers; [ rafaelsgirao ];
    platforms = platforms.unix;
  };
}
