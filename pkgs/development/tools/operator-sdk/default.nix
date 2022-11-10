{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xIO8/o3XEaWQJM5YaPE3gmxm3CsGKV/OBPla6FqAN0Y=";
  };

  vendorSha256 = "sha256-1Vz+SIrNULajDqzZt53+o9wv1zLPBvKrO28BTqS4VbM=";

  doCheck = false;

  subPackages = [ "cmd/operator-sdk" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ go ];

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
