{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "grpcui";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "fullstorydev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9rKZFbRJn/Rv/9vznBujEt0bSCvx9eLKADoYc4pXBeY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-DTLguUSFgGOF+okHQdFxL944NA+WPWT1zaeu38p1p0M=";
=======
  vendorSha256 = "sha256-DTLguUSFgGOF+okHQdFxL944NA+WPWT1zaeu38p1p0M=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/grpcui" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "An interactive web UI for gRPC, along the lines of postman";
    homepage = "https://github.com/fullstorydev/grpcui";
    license = licenses.mit;
    maintainers = with maintainers; [ pradyuman ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
