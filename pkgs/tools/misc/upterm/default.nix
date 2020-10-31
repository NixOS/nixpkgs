{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "upterm";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "owenthereal";
    repo = "upterm";
    rev = "v${version}";
    sha256 = "1p7bwg8zlp45j5758wfbkpc95rpsa8xq0hn439bd2knrdsdadnnk";
  };

  doCheck = false;

  vendorSha256 = null;

  meta = with lib; {
    description = "secure terminal-session sharing";
    homepage = "https://upterm.dev";
    license = licenses.asl20;
    maintainers = [ maintainers.gilligan ];
  };
}
