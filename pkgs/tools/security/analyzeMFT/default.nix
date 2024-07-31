{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "analyzeMFT";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "rowingdude";
    repo = "analyzeMFT";
    rev = "b6ed04faaf0210708fde75488d4399a1a6bd4822";
    hash = "sha256-DeEHGlP0o9zSCPA4bERVpkgesPIF9Ln2ET8cVmYk3HY=";
  };

  meta = with lib; {
    description = ''
      analyzeMFT.py is designed to fully parse the MFT file from an NTFS filesystem
      and present the results as accurately as possible in multiple formats.'';
    homepage = "https://github.com/rowingdude/analyzeMFT";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ MikeHorn-git ];
    mainProgram = "analyzeMFT";
  };
}
