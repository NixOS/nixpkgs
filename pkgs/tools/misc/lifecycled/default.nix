{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
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

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-KmrGTCKjFSK9mZWgox+EBVK6aQ7xUs9fAvCnNCY5eDY=";

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

