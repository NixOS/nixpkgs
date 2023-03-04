{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.28.7";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-6oOIKvUocImC3HMeG5aJXLlruymechcsDhMxEyYiNzU=";
  };

  vendorHash = "sha256-/4xZjqstrjfIlD15x2INSunb57WGR7NzKaQxUABxQV0=";

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
