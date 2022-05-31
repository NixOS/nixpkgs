{ lib, buildPythonApplication, fetchPypi, installShellFiles }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1612";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-lKEztwwn1pnALuwDiA1Ik9+XCVyO+UMobv+hXu0mn5w=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd you-get \
      --zsh contrib/completion/_you-get \
      --fish contrib/completion/you-get.fish \
      --bash contrib/completion/you-get-completion.bash
  '';

  meta = with lib; {
    description = "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    changelog = "https://github.com/soimort/you-get/raw/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
