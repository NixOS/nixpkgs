{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.28.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-qag8e7m4mfHmaeMg//sAZpiHTIoXt1vQMKv5PdtvvKc=";
  };

  vendorHash = "sha256-CVCAP2JMfLN23Sgf2d+CSK4uetomWzPUX0BRmutW7pI=";

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
