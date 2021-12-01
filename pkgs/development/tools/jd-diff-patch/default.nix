{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jd-diff-patch";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner  = "josephburnett";
    repo   = "jd";
    rev    = "v${version}";
    sha256 = "sha256-OAy4IS2JZYYPeJITNHZKiYEapzGqqYPDBCLflLYetzg=";
  };

  # not including web ui
  excludedPackages = [ "gae" "pack" ];

  vendorSha256 = "sha256-w3mFra7Je+8qIDQMSyUYucoLZ6GtrZmr56O6xmihIYc=";

  doCheck = true;

  meta = with lib; {
    description = "Commandline utility and Go library for diffing and patching JSON values";
    homepage = "https://github.com/josephburnett/jd";
    license = licenses.mit;
    maintainers = with maintainers; [ bryanasdev000 blaggacao ];
  };
}
