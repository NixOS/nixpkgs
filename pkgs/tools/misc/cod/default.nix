{ stdenv, lib, fetchFromGitHub, buildGoModule, python3 }:

buildGoModule rec {
  pname = "cod";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dim-an";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mT7OkR8fXXTE3TPx9AmH6ehKGLk4CP9euBPs2zVAJnI=";
  };

  vendorHash = "sha256-kezfBDTgpOTBYKTNlwuP+M5tXU2w/MXz0B5nBJcL1io=";

  ldflags = [ "-s" "-w" "-X main.GitSha=${src.rev}" ];

  nativeCheckInputs = [ python3 ];

  preCheck = ''
    pushd test/binaries/
    for f in *.py; do
      patchShebangs ''$f
    done
    popd
    export COD_TEST_BINARY="''${NIX_BUILD_TOP}/go/bin/cod"

    substituteInPlace test/learn_test.go --replace TestLearnArgparseSubCommand SkipLearnArgparseSubCommand
  '';

  meta = with lib; {
    description = "Tool for generating Bash/Fish/Zsh autocompletions based on `--help` output";
    homepage = "https://github.com/dim-an/cod/";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
    broken = stdenv.isDarwin;
  };
}
