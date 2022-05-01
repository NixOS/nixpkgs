{ lib
, fetchFromGitHub
, fetchpatch
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "sha256-KDDk0QSOjwivJFz3vLk+g4vZMlSuX2FiOgHJfDJkpwg=";
  };

  patches = [
    # add support for systemd socket activation
    (fetchpatch {
      url = "https://github.com/jelmer/xandikos/pull/155.diff";
      sha256 = "sha256-h2E0DSeWMkuUytMiu+uUsEJI22fszNCOxEqvPlXMYek=";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    prometheus-client
    systemd
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  checkInputs = with python3Packages; [ pytestCheckHook ];
  disabledTests = [
    # these tests are failing due to the following error:
    # TypeError: expected str, bytes or os.PathLike object, not int
    "test_iter_with_etag"
    "test_iter_with_etag_missing_uid"
  ];

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
