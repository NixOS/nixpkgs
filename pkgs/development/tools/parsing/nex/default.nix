{ buildGoPackage
, fetchFromGitHub
, lib
}:
# upstream is pretty stale, but it still works, so until they merge module
# support we have to use gopath: see blynn/nex#57
buildGoPackage rec {
  pname = "nex";
  version = "unstable-2021-03-30";

  src = fetchFromGitHub {
    owner = "blynn";
    repo = pname;
    rev = "1a3320dab988372f8910ccc838a6a7a45c8980ff";
    hash = "sha256-DtJkV380T2B5j0+u7lYZfbC0ej0udF4GW2lbRmmbjAM=";
  };

  goPackagePath = "github.com/blynn/nex";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Lexer for Go";
    mainProgram = "nex";
    homepage = "https://github.com/blynn/nex";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
