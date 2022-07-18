{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner  = "josephburnett";
    repo   = "jd";
    rev    = "v${version}";
    sha256 = "sha256-NUga7Rxh/hCEw6bZvbxsqBoIKdG2TTfEXdwHY42cgxE=";
  };

  # not including web ui
  excludedPackages = [ "gae" "pack" ];

  vendorSha256 = "sha256-uoMOkCmJY417zxkTsXHGy+BZ/BH29nH4MhFaIKofh4k=";

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 blaggacao ];
    mainProgram = "jd";
  };
}
