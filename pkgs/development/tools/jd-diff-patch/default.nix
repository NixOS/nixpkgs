{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner  = "josephburnett";
    repo   = "jd";
    rev    = "v${version}";
    sha256 = "sha256-nYV72EgYgXWyGp2s09BlaRmOy6aSMtmrTvWCxk9znp0=";
  };

  # not including web ui
  excludedPackages = [ "gae" "pack" ];

  vendorSha256 = "sha256-uoMOkCmJY417zxkTsXHGy+BZ/BH29nH4MhFaIKofh4k=";

  doCheck = true;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 blaggacao ];
  };
}
