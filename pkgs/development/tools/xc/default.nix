{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "xc";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "joerdav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ndaffdU+DYuILZzAwsjLTNWFWbq7CrTcAYBA0j3T3gA=";
  };

  vendorHash = "sha256-AwlXX79L69dv6wbFtlbHAeZRuOeDy/r6KSiWwjoIgWw=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  meta = with lib; {
    description = "Markdown defined task runner";
    homepage = "https://xcfile.dev/";
    changelog = "https://github.com/joerdav/xc/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda joerdav ];
  };
}
