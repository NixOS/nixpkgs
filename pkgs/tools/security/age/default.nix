{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0-rc.1";
  vendorSha256 = "1qx6pkhq00y0lsi6f82g8hxxh65zk1c0ls91ap6hdlj7ch79bhl2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "1n25wip4qnd3v9ial1apc2ybx10b9z6lwz7flyss6kvj3x5g9jd1";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
