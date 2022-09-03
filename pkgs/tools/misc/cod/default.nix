{ stdenv, lib, fetchFromGitHub, buildGoModule, python3 }:

buildGoModule rec {
  pname = "cod";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dim-an";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wi680sxpv0kp1ggy21qp4c4ms79hw4z9w9kvp278p8z3y8wwglr";
  };

  vendorSha256 = "0ann1fbh8rqys3rwbz5h9mfnvkpqiw5rgkd4c30y99706h2dzv4i";

  ldflags = [ "-s" "-w" "-X main.GitSha=${src.rev}" ];

  checkInputs = [ python3 ];

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
    broken = true;
  };
}
