{ lib
, buildPythonApplication
, fetchPypi
, mock
, pytestCheckHook
, six
}:

buildPythonApplication rec {
  pname = "wad";
  version = "0.4.6";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "02jq77h6g9v7n4qqq7qri6wmhggy257983dwgmpjsf4qsagkgwy8";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "wad" ];

  meta = with lib; {
    description = "Tool for detecting technologies used by web applications";
    longDescription = ''
      WAD lets you analyze given URL(s) and detect technologies used by web
      application behind that URL, from the OS and web server level, to the
      programming platform and frameworks, as well as server- and client-side
      applications, tools and libraries.
    '';
    homepage = "https://github.com/CERN-CERT/WAD";
    # wad is GPLv3+, wappalyzer source is MIT
    license = with licenses; [ gpl3Plus mit ];
    maintainers = with maintainers; [ fab ];
  };
}
