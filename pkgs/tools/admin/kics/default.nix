<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
=======
{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, testers
, kics
}:

buildGoModule rec {
  pname = "kics";
<<<<<<< HEAD
  version = "1.7.7";
=======
  version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Checkmarx";
    repo = "kics";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qK1lq7jrej4HdM+BUDDPujhbhqEhKcli3CTAmadO5Mg=";
  };

  vendorHash = "sha256-gJu3B30IPp8A/xgtE5fzThQAtnFbbzr8ZwucAsObBxs=";
=======
    sha256 = "sha256-T9dO8OGlbEvjM+9P7cbCCgXkJXXtkR+5zrXRoGZg08c=";
  };

  vendorHash = "sha256-Sg8f6fqe7DAsNsEGU1Ml42qgSuE5CrD+YrFqZKpNKtU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "cmd/console" ];

  postInstall = ''
    mv $out/bin/console $out/bin/kics
  '';

  ldflags = [
    "-s" "-w"
    "-X github.com/Checkmarx/kics/internal/constant.SCMCommits=${version}"
    "-X github.com/Checkmarx/kics/internal/constants.Version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = kics;
    command = "kics version";
  };

  meta = with lib; {
    description = ''
      Find security vulnerabilities, compliance issues, and infrastructure misconfigurations early in the development
      cycle of your infrastructure-as-code with KICS by Checkmarx.
    '';
    homepage = "https://github.com/Checkmarx/kics";
    license = licenses.asl20;
    maintainers = with maintainers; [ patryk4815 ];
  };
}
