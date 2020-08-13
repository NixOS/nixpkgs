{ lib, fetchFromGitHub, python3Packages,
  # test dependencies
  bc, jq }:

with python3Packages;

buildPythonApplication rec {
  pname = "pyp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1p2mqkgqh138vkry0rc4d65ksffypsqlbza1dzc9h2prrx8dbysw";
  };

  buildInputs = [ astunparse ];
  checkInputs = [ pytest bc jq ];
  checkPhase = ''
    PATH=$out/bin:$PATH pytest
  '';

  meta = with lib; {
    description = "Easily run Python at the shell";
    homepage = "https://github.com/hauntsaninja/pyp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.Kha ];
  };
}
