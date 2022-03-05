{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-zWxw4LZIlkT88yGTnxdupq7cUSacNRxPzzp01O9USDw=";
  };

  vendorSha256 = "sha256-zteMlrvRTVxOFlBy+z/qfiSii8+c8PMapwIsdbN+Aig=";

  postInstall = ''
    mv $out/bin/cni-plugin $out/bin/flannel
  '';

  doCheck = false;
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/flannel 2>&1 | fgrep -q v$version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "flannel CNI plugin";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
