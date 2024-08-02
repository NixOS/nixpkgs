{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "analyzeMFT";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "rowingdude";
    repo = "analyzeMFT";
    rev = "v${version}";
    hash = "sha256-uZxNW/+BPEZRp/XOlBoDCI4KozQ0svS3OSrR73GmDTg=";
  };

  meta = {
    description = ''
      analyzeMFT.py is designed to fully parse the MFT file from an NTFS filesystem
      and present the results as accurately as possible in multiple formats.'';
    homepage = "https://github.com/rowingdude/analyzeMFT";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ MikeHorn-git ];
    mainProgram = "analyzeMFT";
  };
}
