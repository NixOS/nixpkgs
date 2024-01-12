{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "ory";
  version = "0.3.1";
  vendorHash = "sha256-H1dM/r7gJvjnexQwlA4uhJ7rUH15yg4AMRW/f0k1Ixw=";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-dO595NzdkVug955dqji/ttAPb+sMGLxJftXHzHA37Lo=";
  };

  doCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/ory
    rm $out/bin/{clidoc,e2e}
  '';

  meta = with lib; {
    description = "CLI tool to manage and configure Ory Network projects";
    homepage = "https://github.com/ory/cli";
    license = licenses.asl20;
    mainProgram = "ory";
    maintainers = with maintainers; [ nicolas-goudry ];
  };
}
