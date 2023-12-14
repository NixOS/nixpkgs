{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.12.6";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-WecKgLnfasqNp4G9e24EPjSeA9dqiEhl8KjVQ/KbmKk=";
  };

  vendorHash = "sha256-f9KJyMu4WD96IPTWSuGfQDZvayEbZ+1KeQj/99Ck/I4=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
