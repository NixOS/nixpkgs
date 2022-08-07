{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner  = "josephburnett";
    repo   = "jd";
    rev    = "v${version}";
    sha256 = "sha256-VxCsr7u7Ds3BMtZtnVS0VoLKM46NYLqVZGmRDSyqmtg=";
  };

  # not including web ui
  excludedPackages = [ "gae" "pack" ];

  vendorSha256 = null;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 blaggacao ];
    mainProgram = "jd";
  };
}
