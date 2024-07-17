{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "jp";
  version = "0.2.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "jmespath";
    repo = "jp";
    hash = "sha256-a3WvLAdUZk+Y+L+opPDMBvdN5x5B6nAi/lL8JHJG/gY=";
  };

  vendorHash = "sha256-K6ZNtART7tcVBH5myV6vKrKWfnwK8yTa6/KK4QLyr00=";

  meta = with lib; {
    description = "A command line interface to the JMESPath expression language for JSON";
    mainProgram = "jp";
    homepage = "https://github.com/jmespath/jp";
    maintainers = with maintainers; [ cransom ];
    license = licenses.asl20;
  };
}
