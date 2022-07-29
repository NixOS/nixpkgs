{ lib, stdenv, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "autopair.fish";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = pname;
    rev = version;
    sha256 = "sha256-l6WJ2kjDO/TnU9FSigjxk5xFp90xl68gDfggkE/wrlM=";
  };

  meta = with lib; {
    description = "Auto-complete matching pairs in the Fish command line.";
    homepage = "https://github.com/jorgebucaran/autopair.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ thehedgeh0g ];
  };
}
