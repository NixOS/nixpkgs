{ lib, python3, fetchFromGitHub, nixosTests }:

python3.pkgs.buildPythonApplication rec {
  pname = "radicale";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "Radicale";
    rev = "v${version}";
    hash = "sha256-V0nqgxGUxcTRAYFuxpKUEVB/g/Mbvw+9OIcvAexXwuM=";
  };

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
