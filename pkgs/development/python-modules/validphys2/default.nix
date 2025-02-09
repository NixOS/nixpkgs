{ lib
, buildPythonPackage
, lhapdf
, nnpdf
, prompt-toolkit
, reportengine
, requests
, seaborn
, validobj
}:

buildPythonPackage rec {
  pname = "validphys2";
  version = "4.0";
  format = "setuptools";

  inherit (nnpdf) src;

  prePatch = ''
    cd validphys2
  '';

  postPatch = ''
    substituteInPlace src/validphys/version.py \
      --replace '= __give_git()' '= "'$version'"'
  '';

  propagatedBuildInputs = [
    lhapdf
    nnpdf
    prompt-toolkit
    reportengine
    requests
    seaborn
    validobj
  ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "validphys" ];

  meta = with lib; {
    description = "NNPDF analysis framework";
    homepage = "https://data.nnpdf.science/validphys-docs/guide.html";
    inherit (nnpdf.meta) license;
    maintainers = with maintainers; [ veprbl ];
  };
}
