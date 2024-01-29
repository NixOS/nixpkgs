{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "birdwatcher";
  version = "2.2.4";

  vendorHash = "sha256-NTD2pnA/GeTn4tXtIFJ227qjRtvBFCjWYZv59Rumc74=";

  src = fetchFromGitHub {
    owner = "alice-lg";
    repo = "birdwatcher";
    rev = version;
    hash = "sha256-nsmwq7aUcozpp3av38S9wTKv0kiGfmyglQgse9MWSl4=";
  };

  deleteVendor = true;

  meta = with lib; {
    homepage = "https://github.com/alice-lg/birdwatcher";
    description = "A small HTTP server meant to provide an API defined by Barry O'Donovan's birds-eye to the BIRD internet routing daemon";
    changelog = "https://github.com/alice-lg/birdwatcher/blob/master/CHANGELOG";
    license = licenses.bsd3;
    maintainers = with maintainers; [ janik ];
    mainProgram = "birdwatcher";
  };
}
