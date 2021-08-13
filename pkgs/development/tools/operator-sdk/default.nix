{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qvwk2gyawa3ihi5zqynrimxf426x22kplr3gdb91m9bx9dwqs3v";
  };

  vendorSha256 = "1chfiqxljpq6rad4fnqf3dcri63qr9vb765kphw98ly4s0mwm1aj";

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
