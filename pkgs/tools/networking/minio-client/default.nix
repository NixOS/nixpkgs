{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "minio-client";
<<<<<<< HEAD
  version = "2023-08-15T23-03-09Z";
=======
  version = "2023-05-04T18-10-16Z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "minio";
    repo = "mc";
    rev = "RELEASE.${version}";
<<<<<<< HEAD
    sha256 = "sha256-vsCbmT6uWy+VA0qx8x9hx3pDSVKiDeXjnnrFRnhm4C8=";
  };

  vendorHash = "sha256-xtGXYCmiT7xY9OL8x0tTBP9y8UfzlJ6ZR2DhKOwVgkM=";
=======
    sha256 = "sha256-xh88GOdaeLEZZhCZrms+IovanjgkfQrieHYcofdfZHM=";
  };

  vendorHash = "sha256-d8cC/exdM7OMGE24bN00BVE3jqE1tj6727JiON/aJkc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  patchPhase = ''
    sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
    sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
    sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/mc --version | grep ${version} > /dev/null
  '';

  passthru.tests.minio = nixosTests.minio;

  meta = with lib; {
    homepage = "https://github.com/minio/mc";
    description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
    maintainers = with maintainers; [ bachp eelco ];
    mainProgram = "mc";
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
  };
}
