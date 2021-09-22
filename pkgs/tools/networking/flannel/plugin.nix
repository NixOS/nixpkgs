{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cni-plugin-flannel";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "flannel-io";
    repo = "cni-plugin";
    rev = "v${version}";
    sha256 = "sha256-s2gibebXTqM/12nDHwc89geWxA6gZi9/if5VnUFoTDE=";
  };

  vendorSha256 = "sha256-TLAwE3pTnJYOi1AsOQfsG6t3xLKOah/7DvYjsqyltKs=";

  postInstall = ''
    mv $out/bin/cni-plugin $out/bin/flannel
  '';

  doCheck = false;

  meta = with lib; {
    description = "flannel CNI plugin";
    homepage = "https://github.com/flannel-io/cni-plugin/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbe ];
  };
}
