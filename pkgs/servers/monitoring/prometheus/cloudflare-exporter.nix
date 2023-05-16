{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cloudflare-exporter";
  version = "0.0.14";

  src = fetchFromGitHub {
    rev = version;
    owner = "lablabs";
    repo = pname;
    sha256 = "sha256-A7JnHx9yipTwv63287BqmGrJ3yQ21NhB1z7rrHe6Ok8=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-B/+UTkoGAoJLMr+zdXXSC2CWGHx+Iu5E2qp4AA/nmHM=";
=======
  vendorSha256 = "sha256-B/+UTkoGAoJLMr+zdXXSC2CWGHx+Iu5E2qp4AA/nmHM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Prometheus Cloudflare Exporter";
    homepage = "https://github.com/lablabs/cloudflare-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ bbigras ];
    platforms = platforms.linux;
  };
}
