{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "quicktemplate";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "valyala";
    repo = "quicktemplate";
    rev = "v${version}";
    sha256 = "0xzsvhpllmzmyfg8sj1dpp02826j1plmyrdvqbwryzhf2ci33nqr";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/valyala/quicktemplate";
    description = "Fast, powerful, yet easy to use template engine for Go";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
    mainProgram = "qtc";
  };
}
