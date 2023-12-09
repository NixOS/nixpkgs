{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "zope-event";
  version = "5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.event";
    inherit version;
    hash = "sha256-usRA2NmJG0Bo4rWixeLJdlqd92KUS9ppVflrubkeZ80=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "zope.event"
  ];

  meta = with lib; {
    description = "An event publishing system";
    homepage = "https://github.com/zopefoundation/zope.event";
    changelog = "https://github.com/zopefoundation/zope.event/blob/${version}/CHANGES.rst";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
