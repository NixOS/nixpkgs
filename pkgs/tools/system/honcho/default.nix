{ lib, fetchFromGitHub, python3Packages }:

let
  inherit (python3Packages) python;
  pname = "honcho";

in

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nickstenning";
    repo = "honcho";
    rev = "v${version}";
    sha256 = "1y0r8dw4pqcq7r4n58ixjdg1iy60lp0gxsd7d2jmhals16ij71rj";
  };

  propagatedBuildInputs = [ python3Packages.setuptools ];

  nativeCheckInputs = with python3Packages; [ jinja2 pytest mock coverage ];

  # missing plugins
  doCheck = false;

  checkPhase = ''
    runHook preCheck
    PATH=$out/bin:$PATH coverage run -m pytest
    runHook postCheck
  '';

  meta = with lib; {
    description = "A Python clone of Foreman, a tool for managing Procfile-based applications";
    license = licenses.mit;
    homepage = "https://github.com/nickstenning/honcho";
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
