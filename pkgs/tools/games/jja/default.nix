{ lib
, stdenv
, rustPlatform
, pkg-config
, openssl
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "jja";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-+MIEdEyQKnIzkBeIhKPNkSIICflEfE7vG1afcrU6Mws=";
  };
  cargoSha256 = "sha256-aaimBJIJI+bWMQcUPwFvCVNp6DyRc6OV3O9yTu7+K1g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "A command line utility to interact with various chess file formats";
    homepage = "https://git.sr.ht/~alip/jja";
    platforms = platforms.all;
    license = licenses.gpl3;
    maintainers = with maintainers; [ seppesoete ];
  };
}
