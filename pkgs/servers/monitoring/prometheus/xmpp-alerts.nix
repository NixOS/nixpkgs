{ lib
, fetchFromGitHub
, python3Packages
, prometheus-alertmanager
, fetchpatch
, runCommand
, prometheus-xmpp-alerts
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PwShGS1rbfZCK5OS6Cnn+mduOpWAD4fC69mcGB5GB1c=";
  };

  patches = [
    # Required until https://github.com/jelmer/prometheus-xmpp-alerts/pull/33 is merged
    # and contained in a release
    (fetchpatch {
      name = "Fix-outdated-entrypoint-definiton.patch";
      url = "https://github.com/jelmer/prometheus-xmpp-alerts/commit/c41dd41dbd3c781b874bcf0708f6976e6252b621.patch";
      hash = "sha256-G7fRLSXbkI5EDgGf4n9xSVs54IPD0ev8rTEFffRvLY0=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "bs4" "beautifulsoup4"
  '';

  propagatedBuildInputs = [
    prometheus-alertmanager
  ] ++ (with python3Packages; [
    aiohttp
    aiohttp-openmetrics
    beautifulsoup4
    jinja2
    slixmpp
    prometheus-client
    pyyaml
  ]);

  nativeCheckInputs = with python3Packages; [
    unittestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "prometheus_xmpp" ];

  passthru.tests = {
    binaryWorks = runCommand "${pname}-binary-test" {} ''
      # Running with --help to avoid it erroring due to a missing config file
      ${prometheus-xmpp-alerts}/bin/prometheus-xmpp-alerts --help | tee $out
      grep "usage: prometheus-xmpp-alerts" $out
    '';
  };

  meta = {
    description = "XMPP Web hook for Prometheus";
    homepage = "https://github.com/jelmer/prometheus-xmpp-alerts";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
