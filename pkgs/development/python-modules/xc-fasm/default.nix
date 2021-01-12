{ stdenv
, fetchFromGitHub
, buildPythonPackage
, pytestCheckHook
, simplejson
, intervaltree
, python-prjxray
, symbiflow-fasm
, textx
}:

buildPythonPackage rec {
  pname = "xc-fasm";
  version = "0.0.1-g0ddd9516";

  src = fetchFromGitHub {
    owner = "SymbiFlow";
    repo = "xc-fasm";
    rev = "0ddd951602d47d5b95f2072f8aa751af5e81e577";
    sha256 = "15bzw92sx99s0zldr48na4yhrnp7b90nxsd8ya6ag1pvvijp2al4";
  };

  propagatedBuildInputs = [
    simplejson
    intervaltree
    python-prjxray
    symbiflow-fasm
    textx
  ];

  # Pip will check for and then install missing dependecies.
  # Because some of them are installed from git, it will try
  # to download them even if they're present in
  # propagatedBuildInputs.
  pipInstallFlags = [ "--no-deps" ];

  checkInputs = [ pytestCheckHook ];

  meta = with stdenv.lib; {
    description = "XC FASM libraries";
    homepage = "https://github.com/SymbiFlow/xc-fasm";
    license = licenses.isc;
    maintainers = with maintainers; [ mcaju ];
  };
}
