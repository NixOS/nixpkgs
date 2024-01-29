{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "wgo";
  version = "0.5.4";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "bokwoon95";
    repo = "wgo";
    rev = "v${version}";
    hash = "sha256-MPmB6G5JCIEfFYchVmV8sS5Zfzfui9tClDI6RlLdP6U=";
  };

  vendorHash = "sha256-w6UJxZToHbbQmuXkyqFzyssFcE+7uVNqOuIF/XKdEsU=";

  ldflags = [ "-s" "-w" ];

  subPackages = [ "." ];

  checkFlags = [
    # Flaky tests.
    # See https://github.com/bokwoon95/wgo/blob/e0448e04b6ca44323f507d1aca94425b7c69803c/START_HERE.md?plain=1#L26.
    "-skip=TestWgoCmd_FileEvent"
  ];

  meta = with lib; {
    description = "Live reload for Go apps";
    homepage = "https://github.com/bokwoon95/wgo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
