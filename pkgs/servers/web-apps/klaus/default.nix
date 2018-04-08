{ lib, python, fetchFromGitHub }:

python.pkgs.buildPythonApplication rec {
  pname = "klaus";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "jonashaag";
    repo = pname;
    rev = version;
    sha256 = "0hkl1ycyd5ccijmknr3yfp3ga43y01m7390xnibqqgaisfvcm9wp";
  };

  prePatch = ''
    substituteInPlace runtests.sh \
      --replace "mkdir -p \$builddir" "mkdir -p \$builddir && pwd"
  '';

  propagatedBuildInputs = with python.pkgs; [
    six flask pygments dulwich httpauth humanize
  ];

  checkInputs = with python.pkgs; [
    pytest requests python-ctags3
  ] ++ lib.optional (!isPy3k) mock;

  checkPhase = ''
    ./runtests.sh
  '';

  # Needs to set up some git repos
  doCheck = false;

  meta = with lib; {
    description = "The first Git web viewer that Just Works";
    homepage    = https://github.com/jonashaag/klaus;
    license     = licenses.isc;
    maintainers = with maintainers; [ ];
  };
}
