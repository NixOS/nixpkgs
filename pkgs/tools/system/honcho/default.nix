{ stdenv, fetchFromGitHub, pythonPackages }:

let
  inherit (pythonPackages) python;
  pname = "honcho";

in

pythonPackages.buildPythonApplication rec {
  name = "${pname}-${version}";
  version = "1.0.1";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "nickstenning";
    repo = "honcho";
    rev = "v${version}";
    sha256 = "11bd87474qpif20xdcn0ra1idj5k16ka51i658wfpxwc6nzsn92b";
  };

  buildInputs = with pythonPackages; [ jinja2 pytest mock coverage ];

  buildPhase = ''
    ${python.interpreter} setup.py build
  '';

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"
  '';

  checkPhase = ''
    runHook preCheck
    PATH=$out/bin:$PATH coverage run -m pytest
    runHook postCheck
  '';

  meta = with stdenv.lib; {
    description = "A Python clone of Foreman, a tool for managing Procfile-based applications";
    license = licenses.mit;
    homepage = https://github.com/nickstenning/honcho;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
