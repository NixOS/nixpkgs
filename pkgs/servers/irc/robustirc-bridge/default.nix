{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "robustirc-bridge";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "robustirc";
    repo = "bridge";
    rev = "v${version}";
    hash = "sha256-8SNy3xqVahBuEXCrG21zIggXeahbzJtqtFMxfp+r48g=";
  };

  vendorHash = "sha256-NBouR+AwQd7IszEcnYRxHFKtCdVTdfOWnzYjdZ5fXfs=";

  postInstall = ''
    install -D robustirc-bridge.1 $out/share/man/man1/robustirc-bridge.1
  '';

  passthru.tests.robustirc-bridge = nixosTests.robustirc-bridge;

  meta = with lib; {
    description = "Bridge to robustirc.net-IRC-Network";
    mainProgram = "robustirc-bridge";
    homepage = "https://robustirc.net/";
    license = licenses.bsd3;
    maintainers = [ maintainers.hax404 ];
  };
}
