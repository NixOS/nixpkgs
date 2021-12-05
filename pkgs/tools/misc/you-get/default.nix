{ lib, buildPythonApplication, fetchPypi, installShellFiles }:

buildPythonApplication rec {
  pname = "you-get";
  version = "0.4.1555";

  # Tests aren't packaged, but they all hit the real network so
  # probably aren't suitable for a build environment anyway.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "99282aca720c7ee1d9ef4b63bbbd226e906ea170b789a459fafd5b0627b0b15f";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd you-get \
      --zsh contrib/completion/_you-get \
      --fish contrib/completion/you-get.fish \
      --bash contrib/completion/you-get-completion.bash
  '';

  meta = with lib; {
    description =
      "A tiny command line utility to download media contents from the web";
    homepage = "https://you-get.org";
    changelog =
      "https://github.com/soimort/you-get/raw/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
