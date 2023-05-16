{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "lifecycled";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "lifecycled";
    rev = "v${version}";
    sha256 = "sha256-zskN2T0+1xZPjppggeGpPFuQ8/AgPNyN77F33rDoghc=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-q5wYKSLHRzL+UGn29kr8+mUupOPR1zohTscbzjMRCS0=";
=======
  vendorSha256 = "sha256-q5wYKSLHRzL+UGn29kr8+mUupOPR1zohTscbzjMRCS0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute init/systemd/lifecycled.unit $out/lib/systemd/system/lifecycled.service \
      --replace /usr/bin/lifecycled $out/bin/lifecycled
  '';

  meta = with lib; {
    description = "A daemon for responding to AWS AutoScaling Lifecycle Hooks";
    homepage = "https://github.com/buildkite/lifecycled/";
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h grahamc ];
  };
}

