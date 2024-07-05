{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule {
  pname = "honeytrap";
  version = "unstable-2021-12-20";

  src = fetchFromGitHub {
    owner = "honeytrap";
    repo = "honeytrap";
    rev = "05965fc67deab17b48e43873abc5f509067ef098";
    hash = "sha256-KSVqjHlXl85JaqKiW5R86HCMdtFBwTMJkxFoySOcahs=";
  };

  vendorHash = "sha256-W8w66weYzCpZ+hmFyK2F6wdFz6aAZ9UxMhccNy1X1R8=";

  # Otherwise, will try to install a "scripts" binary; it's only used in
  # dockerize.sh, which we don't care about.
  subPackages = [ "." ];

  meta = with lib; {
    description = "Advanced Honeypot framework";
    mainProgram = "honeytrap";
    homepage = "https://github.com/honeytrap/honeytrap";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
