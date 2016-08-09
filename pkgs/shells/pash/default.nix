{ stdenv, fetchFromGitHub, buildDotnetPackage }:

buildDotnetPackage rec {
  baseName = "pash";
  version = "git-2016-07-06";
  
  src = fetchFromGitHub {
    owner = "Pash-Project";
    repo = "Pash";
    rev = "8d6a48f5ed70d64f9b49e6849b3ee35b887dc254";
    sha256 = "0c4wa8qi1zs01p9ck171jkw0n1rsymsrhpsb42gl7warwhpmv59f";
  };

  preConfigure = "rm -rvf $src/Source/PashConsole/bin/*";

  outputFiles = [ "Source/PashConsole/bin/Release/*" ];

  meta = with stdenv.lib; {
    description = "An open source implementation of Windows PowerShell";
    homepage = https://github.com/Pash-Project/Pash;
    maintainers = [ maintainers.fornever maintainers.vrthra ];
    platforms = platforms.all;
    license = with licenses; [ bsd3 gpl3 ];
  };

  passthru = {
    shellPath = "/bin/pash";
  };
}
