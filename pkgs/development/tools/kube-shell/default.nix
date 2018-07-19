{ lib, pythonPackages, fetchFromGitHub }:

let
  inherit (pythonPackages) python;
in
pythonPackages.buildPythonApplication rec {
  name = "kube-shell-${version}";
  version = "0.0.21";

  src = fetchFromGitHub {
    sha256 = "0966szv0n6mpsxfphv8z4h1h1rikhx4k8z3v5p9b2vmmw8048rn5";
    rev = "v${version}";
    repo = "kube-shell";
    owner = "cloudnativelabs";
  };

  buildInputs = with pythonPackages; [ pexpect ];

  buildPhase = ''
    export HOME=$(mktemp -d)
    ${python.interpreter} setup.py build
  '';

  installPhase = ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${python.interpreter} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --prefix="$out"
  '';

  checkPhase = ''
    PATH="$out/bin:$PATH" ${python.interpreter} kubeshell/tests/test_cli.py
  '';

  meta = with lib; {
    description = "An integrated shell for working with Kubernetes";
    longDescription = ''
      Rich command-line interface for kubectl with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://github.com/cloudnativelabs/kube-shell";
    license = licenses.asl20;
    maintainers = [ maintainers.carlosdagos ];
  };
}
