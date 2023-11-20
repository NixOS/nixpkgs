{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "evmdis";
  version = "unstable-2022-05-09";

  src = fetchFromGitHub {
    owner = "Arachnid";
    repo = "evmdis";
    rev = "7fad4fbee443262839ce9f88111b417801163086";
    hash = "sha256-jfbjXoGT8RtwLlqX13kcKdiFlhrVwA7Ems6abGJVRbA=";
  };

  vendorHash = null;

  preBuild = ''
    # Add go modules support
    cp ${./go.mod} go.mod
  '';

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/Arachnid/evmdis";
    description = "Ethereum EVM disassembler";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ asymmetric ];
  };
}
