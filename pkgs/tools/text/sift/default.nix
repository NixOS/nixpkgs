{ lib, buildGoPackage, fetchFromGitHub, installShellFiles }:

buildGoPackage rec {
  pname = "sift";
  version = "0.9.0";
  rev = "v${version}";

  goPackagePath = "github.com/svent/sift";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "svent";
    repo = "sift";
    sha256 = "0bgy0jf84z1c3msvb60ffj4axayfchdkf0xjnsbx9kad1v10g7i1";
  };

  postInstall = ''
    installShellCompletion --cmd sift --bash go/src/github.com/svent/sift/sift-completion.bash
  '';

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A fast and powerful alternative to grep";
    homepage = "https://sift-tool.org";
    maintainers = with maintainers; [ carlsverre viraptor ];
    license = licenses.gpl3;
  };
}
