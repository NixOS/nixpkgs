{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scalingo";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = "cli";
    rev = version;
    sha256 = "sha256-dMiOGPQ2wodVdB43Sk3GfEFYIU/W2K9DG/4hhVxb1fs=";
  };

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
  ];

  preConfigure = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Command Line client for Scalingo PaaS";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md#1282";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
