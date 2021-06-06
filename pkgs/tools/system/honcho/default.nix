{ lib, fetchFromGitHub, python3Packages }:

let
  inherit (python3Packages) python;
  pname = "honcho";

in

python3Packages.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "nickstenning";
    repo = "honcho";
    rev = "v${version}";
    sha256 = "11bd87474qpif20xdcn0ra1idj5k16ka51i658wfpxwc6nzsn92b";
  };

  checkInputs = with python3Packages; [ jinja2 pytest mock coverage ];

  buildPhase = ''
    ${python.interpreter} setup.py build
  '';

  installPhase = ''
    mkdir -p "$out/${python.sitePackages}"

    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"

    ${python.interpreter} setup.py install \
      --install-lib=$out/${python.sitePackages} \
      --prefix="$out"
  '';

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
