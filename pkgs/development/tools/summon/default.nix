{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "summon";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "cyberark";
    repo = "summon";
    rev = "v${version}";
    hash = "sha256-Y61lVqsKZiHLJF0X4DIq6U7eRXJ0+6I/dBPwXYb2GmQ=";
  };

  vendorHash = "sha256-StcJvUtMfBh7p1sD8ucvHNJ572whRfqz3id6XsFoXtk=";

  subPackages = [ "cmd" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/summon
  '';

  meta = with lib; {
    description =
      "CLI that provides on-demand secrets access for common DevOps tools";
    mainProgram = "summon";
    homepage = "https://cyberark.github.io/summon";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ quentini ];
  };
}
