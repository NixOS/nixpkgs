{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

let
  # The web client verifies, that the server version is a valid datetime string:
  # https://github.com/minio/minio/blob/3a0e7347cad25c60b2e51ff3194588b34d9e424c/browser/app/js/web.js#L51-L53
  #
  # Example:
  #   versionToTimestamp "2021-04-22T15-44-28Z"
  #   => "2021-04-22T15:44:28Z"
  versionToTimestamp = version:
    let
      splitTS = builtins.elemAt (builtins.split "(.*)(T.*)" version) 1;
    in
    builtins.concatStringsSep "" [ (builtins.elemAt splitTS 0) (builtins.replaceStrings [ "-" ] [ ":" ] (builtins.elemAt splitTS 1)) ];
in
buildGoModule rec {
  pname = "minio";
<<<<<<< HEAD
  version = "2023-08-16T20-17-30Z";
=======
  version = "2023-05-04T21-44-30Z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "minio";
    repo = "minio";
    rev = "RELEASE.${version}";
<<<<<<< HEAD
    sha256 = "sha256-VY07ITsR2ISM0V4NgwpayDLakU425JCIjxEJ6YKEzXY=";
  };

  vendorHash = "sha256-KYbfHYls77OH8IWCnO9dSevrJ+2fZmpRQPCKfKCyXME=";
=======
    sha256 = "sha256-CSB7QFKb96QVgcBlfP+ghVlLlPGkcI0um6hC2rp+CWc=";
  };

  vendorHash = "sha256-EthPqudNGnXTixnDRbRXdgOfJHIrIYZ8IHy5BZLSwJQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "." ];

  CGO_ENABLED = 0;

  tags = [ "kqueue" ];

  ldflags = let t = "github.com/minio/minio/cmd"; in [
    "-s" "-w" "-X ${t}.Version=${versionToTimestamp version}" "-X ${t}.ReleaseTag=RELEASE.${version}" "-X ${t}.CommitID=${src.rev}"
  ];

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://www.minio.io/";
    description = "An S3-compatible object storage server";
    changelog = "https://github.com/minio/minio/releases/tag/RELEASE.${version}";
    maintainers = with maintainers; [ eelco bachp ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.agpl3Plus;
  };
}
