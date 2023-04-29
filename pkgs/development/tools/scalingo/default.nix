{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "scalingo";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "Scalingo";
    repo = "cli";
    rev = version;
    sha256 = "sha256-dMiOGPQ2wodVdB43Sk3GfEFYIU/W2K9DG/4hhVxb1fs=";
  };

  preConfigure = ''
    export HOME=$TMPDIR
  '';

  vendorHash = null;

  ldflags = [
    "-w"
    "-s"
  ];

  DISABLE_UPDATE_CHECKER = "true";

  meta = with lib; {
    description = "Command Line client for Scalingo PaaS";
    homepage = "https://doc.scalingo.com/platform/cli/start";
    changelog = "https://github.com/Scalingo/cli/blob/master/CHANGELOG.md#1282";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ cimm ];
    platforms = with lib.platforms; unix;
  };
}
