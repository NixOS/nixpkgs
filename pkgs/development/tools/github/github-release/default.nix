{ buildGoPackage, fetchFromGitHub, lib }:

buildGoPackage rec {
  pname = "github-release";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "github-release";
    repo = "github-release";
    rev = "v${version}";
    sha256 = "sha256-J5Y0Kvon7DstTueCsoYvw6x4cOH/C1IaVArE0bXtZts=";
  };

  goPackagePath = "github.com/github-release/github-release";

  meta = with lib; {
    description = "Commandline app to create and edit releases on Github (and upload artifacts)";
    longDescription = ''
      A small commandline app written in Go that allows you to easily create and
      delete releases of your projects on Github.
      In addition it allows you to attach files to those releases.
    '';

    license = licenses.mit;
    homepage = "https://github.com/github-release/github-release";
    maintainers = with maintainers; [ ardumont j03 ];
    platforms = with platforms; unix;
  };
}
