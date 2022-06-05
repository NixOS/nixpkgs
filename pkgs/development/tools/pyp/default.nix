{ lib, fetchFromGitHub, python3Packages,
  # test dependencies
  bc, jq
}:

with python3Packages;

buildPythonApplication rec {
  pname = "pyp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hauntsaninja";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-9eHmSdTOhZSAdCVIuomP/fyknrA3PWo6eI28A8/xZyY=";
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
