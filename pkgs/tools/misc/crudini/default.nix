{ lib, fetchFromGitHub, python3Packages, help2man, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "pixelb";
    repo = "crudini";
    rev = version;
    sha256 = "0298hvg0fpk0m0bjpwryj3icksbckwqqsr9w1ain55wf5s0v24k3";
  };

  nativeBuildInputs = [ help2man installShellFiles ];

  propagatedBuildInputs = with python3Packages; [ iniparse ];

  postPatch = ''
    substituteInPlace crudini-help \
      --replace ./crudini $out/bin/crudini
    substituteInPlace tests/test.sh \
      --replace ..: $out/bin:
  '';

  postInstall = ''
    # this just creates the man page
    make all

    install -Dm444 -t $out/share/doc/${pname} README EXAMPLES
    installManPage *.1
  '';

  checkPhase = ''
    runHook preCheck

    pushd tests >/dev/null
    bash ./test.sh
    popd >/dev/null

    runHook postCheck
  '';

  meta = with lib; {
    description = "A utility for manipulating ini files ";
    homepage = "https://www.pixelbeat.org/programs/crudini/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
