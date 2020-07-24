{ stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "kubectx";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c7y5hj4w72bm6y3riw0acayn4w9x7bbf1vykqcprbyw3a3dvcsw";
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
