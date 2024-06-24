{ buildGoModule
, fetchFromGitHub
, lib
}:
# upstream is pretty stale, but it still works, so until they merge module
# support we have to use gopath: see blynn/nex#57
buildGoModule rec {
  pname = "nex";
  version = "0-unstable-2021-03-30";

  src = fetchFromGitHub {
    owner = "blynn";
    repo = pname;
    rev = "1a3320dab988372f8910ccc838a6a7a45c8980ff";
    hash = "sha256-DtJkV380T2B5j0+u7lYZfbC0ej0udF4GW2lbRmmbjAM=";
  };

  vendorHash = null;

  postPatch = ''
    go mod init github.com/blynn/nex
  '';

  subPackages = [ "." ];

  # Fails with 'nex_test.go:23: got: 7a3661f13445ca7b51de2987bea127d9 wanted: 13f760d2f0dc1743dd7165781f2a318d'
  # Checks failed on master before, but buildGoPackage had checks disabled.
  doCheck = false;

  meta = with lib; {
    description = "Lexer for Go";
    mainProgram = "nex";
    homepage = "https://github.com/blynn/nex";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
