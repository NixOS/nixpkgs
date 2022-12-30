{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "v${version}";
    sha256 = "sha256-rse5uyQ7EUBhs0IyC92B/Z7YCeNIXTlZEqrlcjFekgA=";
  };

  vendorSha256 = "sha256-KyyJ7hUWF29L8oB9GkJ918/BQoLMsz+tStT2T9Azunk=";

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}
  '';

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    license = with licenses; [ agpl3 ];
    maintainers = with maintainers; [ ];
  };
}
