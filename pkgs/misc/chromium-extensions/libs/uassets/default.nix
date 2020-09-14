{ stdenv, fetchFromGitHub }:
with stdenv.lib;

stdenv.mkDerivation {
  pname = "uassets";
  version = "git-2020-09-14";

  src = fetchFromGitHub {
    owner = "uBlockOrigin";
    repo = "uAssets";
    rev = "c8b9400997e1ad4628ca4a4c8c9b4a43d9d4ea42";
    sha256 = "1ll9dgn7rbsiq2ingyd801pgid4rjs97rs4h5lp4hnzmwjp9xiql";
  };

  installPhase = ''
    cp -r . $out
  '';

  meta = {
    description = "Resources for uBlock Origin, uMatrix: static filter lists, ready-to-use rulesets, etc";
    homepage = "https://github.com/uBlockOrigin/uAssets";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
