{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.27.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-zhzYBub5TnJvInMAcAzvh78o4MWHD4EJNn8PbtvHies=";
  };

  vendorHash = "sha256-IiMFSYZ7kdb5HHPFuRJKi+WXLdERSwyph1vSEQ/7RRk=";

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}
  '';

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
