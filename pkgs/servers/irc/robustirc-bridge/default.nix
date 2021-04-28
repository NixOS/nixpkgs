{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "robustirc-bridge";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "robustirc";
    repo = "bridge";
    rev = "v${version}";
    sha256 = "12jzil97147f978shdgm6whz7699db0shh0c1fzgrjh512dw502c";
  };

  vendorSha256 = "0lm8j2iz0yysgi0bbh78ca629kb6sxvyy9al3aj2587hpvy79q85";

  postInstall = ''
    install -D robustirc-bridge.1 $out/share/man/man1/robustirc-bridge.1
  '';

  passthru.tests.robustirc-bridge = nixosTests.robustirc-bridge;

  meta = with lib; {
    description = "Bridge to robustirc.net-IRC-Network";
    homepage = "https://robustirc.net/";
    license = licenses.bsd3;
    maintainers = [ maintainers.hax404 ];
  };
}
