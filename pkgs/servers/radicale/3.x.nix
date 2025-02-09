{ lib
, python3
, fetchFromGitHub
, fetchpatch
, nixosTests
}:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = "v${version}";
    hash = "sha256-V0nqgxGUxcTRAYFuxpKUEVB/g/Mbvw+9OIcvAexXwuM=";
  };

  patches = [
    # https://github.com/Kozea/Radicale/pull/1328
    (fetchpatch {
      name = "fix-python3.11-tests.patch";
      url = "https://github.com/Kozea/Radicale/commit/110ec3a7885f523ce894a8c0e336c1a081dcd092.patch";
      hash = "sha256-WEiwzJ+Vzv8PXmZUi1X7Qzs+oE6qgmpvHqm/xiOMrt0=";
    })
  ];

  postPatch = ''
    sed -i '/addopts/d' setup.cfg
  '';

  propagatedBuildInputs = with python3.pkgs; [
    defusedxml
    passlib
    vobject
    python-dateutil
    pytz # https://github.com/Kozea/Radicale/issues/816
  ] ++ passlib.optional-dependencies.bcrypt;

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    waitress
  ];

  passthru.tests = {
    inherit (nixosTests) radicale;
  };

  meta = with lib; {
    homepage = "https://radicale.org/v3.html";
    description = "CalDAV and CardDAV server";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda erictapen ];
  };
}
