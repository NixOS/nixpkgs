{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tailspin";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "bensadeh";
    repo = "tailspin";
    rev = version;
    hash = "sha256-xbnJ2QoTrJwzWIm/GfYW9QCn0DsfA9jLC6rwik4Pxs8=";
  };

  cargoHash = "sha256-ios/qRp2crV3g7g/jATuUp/zBdDOCEMhAWfeKFM8NdM=";

  meta = with lib; {
    description = "A log file highlighter";
    homepage = "https://github.com/bensadeh/tailspin";
    changelog = "https://github.com/bensadeh/tailspin/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "tspin";
  };
}
