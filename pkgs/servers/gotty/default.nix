{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gotty-${version}";
  version = "0.0.13";
  rev = "v${version}";

  goPackagePath = "github.com/yudai/gotty";

  src = fetchFromGitHub {
    inherit rev;
    owner = "yudai";
    repo = "gotty";
    sha256 = "1hsfjyjjzr1zc9m8bnhid1ag6ipcbx59111y9p7k8az8jiyr112g";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Share your terminal as a web application";
    homepage = https://github.com/yudai/gotty;
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.mit;
  };
}
