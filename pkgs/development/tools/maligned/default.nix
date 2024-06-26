{
  lib,
  buildGoModule,
  fetchFromGitHub,
  go,
}:

buildGoModule rec {
  pname = "maligned";
  version = "unstable-2022-02-04";
  rev = "d7cd9a96ae47d02b08234503b54709ad4ae82105";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "maligned";
    inherit rev;
    sha256 = "sha256-exljmDNtVhjJkvh0EomcbBXSsmQx4I59MHDfMWSQyKk=";
  };

  vendorHash = "sha256-q/0lxZWk3a7brMsbLvZUSZ8XUHfWfx79qxjir1Vygx4=";

  allowGoReference = true;

  nativeCheckInputs = [ go ];

  meta = with lib; {
    description = "Tool to detect Go structs that would take less memory if their fields were sorted";
    mainProgram = "maligned";
    homepage = "https://github.com/mdempsky/maligned";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
