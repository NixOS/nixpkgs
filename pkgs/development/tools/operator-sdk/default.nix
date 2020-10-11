{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p2ra7mqn7crip6sjgq2j49782ncvs4qahjwg6jk5rdvvi4hbyc7";
  };

  vendorSha256 = "0zy540cbfm1kfc5sp802a9a5l2gkpgqprn8mlh9zg4d4shni61wa";

  doCheck = false;

  subPackages = [ "cmd/operator-sdk" ];

  buildInputs = [ go makeWrapper ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;
  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
