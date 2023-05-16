{ lib
, buildGoModule
, fetchFromGitHub
, testers
, tbls
}:

buildGoModule rec {
  pname = "tbls";
<<<<<<< HEAD
  version = "1.68.2";
=======
  version = "1.65.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = "tbls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-yDWAKkzRb487iZ+5tmIH1qfuHj0TldOT+tTQwtVyX7s=";
  };

  vendorHash = "sha256-V6TF7Q+9XxBeSVXlotu8tUrNCWDr80BZsQcVSBGikl8=";
=======
    hash = "sha256-/RyDv256qbi1CMHmB2LZxMBqOM81nA3r5N8jRrww/mQ=";
  };

  vendorHash = "sha256-qT8YhNZ+9n9+VduW8a/tr74w3OyWue7a51667Q9dMCg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  CGO_CFLAGS = [ "-Wno-format-security" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/k1LoW/tbls.commit=unspecified"
    "-X github.com/k1LoW/tbls.date=unspecified"
    "-X github.com/k1LoW/tbls.version=${src.rev}"
    "-X github.com/k1LoW/tbls/version.Version=${src.rev}"
  ];

  preCheck = ''
    # Remove tests that require additional services.
    rm -f \
       datasource/datasource_test.go \
       drivers/*/*_test.go
  '';

  passthru.tests.version = testers.testVersion {
    package = tbls;
    command = "tbls version";
    version = src.rev;
  };

  meta = with lib; {
    description = "A tool to generate documentation based on a database";
    homepage = "https://github.com/k1LoW/tbls";
    changelog = "https://github.com/k1LoW/tbls/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
