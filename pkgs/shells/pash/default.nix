{ stdenv, fetchFromGitHub, buildDotnetPackage }:

buildDotnetPackage rec {
  baseName = "pash";
  version = "git-2015-11-06";
  
  src = fetchFromGitHub {
    owner = "Pash-Project";
    repo = "Pash";
    rev = "50695a28eaf6c8cbfdc8ecddd91923c64e07b618";
    sha256 = "17hs1f6ayk9qyyh1xsydk46n6na7flh2kbd36dynk86bnda5d3bn";
  };

  preConfigure = "rm -rvf $src/Source/PashConsole/bin/*";

  outputFiles = [ "Source/PashConsole/bin/Release/*" ];

  meta = with stdenv.lib; {
    description = "An open source implementation of Windows PowerShell";
    homepage = https://github.com/Pash-Project/Pash;
    maintainers = [ maintainers.fornever ];
    platforms = platforms.all;
    license = with licenses; [ bsd3 gpl3 ];
  };
}
