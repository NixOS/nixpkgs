{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b22jk8zl944w5zn3s7ybkkbmzp9519x32pfqwd1malfly7dzf55";
  };

  vendorSha256 = "168hfdc2rfwpz2ls607bz5vsm1aw4brhwm8hmbiq1n1l2dn2dj0y";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion completion/*
  '';

  meta = with stdenv.lib; {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = "https://github.com/ahmetb/kubectx";
    maintainers = with maintainers; [ jlesquembre ];
    platforms = with platforms; unix;
  };
}
