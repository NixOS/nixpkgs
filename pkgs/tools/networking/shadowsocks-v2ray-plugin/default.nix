{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shadowsocks-v2ray-plugin";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "v2ray-plugin";
    rev = "v${version}";
    sha256 = "sha256-sGsGdJp20mXvJ6Ov1QjztbJxNpDaDEERcRAAyGgenVk=";
  };

  vendorSha256 = "sha256-vW8790Z4BacbdqANWO41l5bH5ac/TSZIdVNvOFVTsZ8=";

  meta = with lib; {
    description = "Yet another SIP003 plugin for shadowsocks, based on v2ray";
    homepage = "https://github.com/shadowsocks/v2ray-plugin/";
    license = licenses.mit;
    maintainers = [ maintainers.ahrzb ];
    mainProgram = "v2ray-plugin";
  };
}

