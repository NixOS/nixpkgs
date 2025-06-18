{
  lib,
  fetchFromGitHub,
  python3Packages,
  prometheus-alertmanager,
  runCommand,
  prometheus-xmpp-alerts,
}:

python3Packages.buildPythonApplication rec {
  pname = "prometheus-xmpp-alerts";
  version = "0.5.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iwqcowwJktZQfdxykpsw/MweAPY0KF7ojVwvk1LP8a4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "bs4" "beautifulsoup4"
  '';

  propagatedBuildInputs =
    [
      prometheus-alertmanager
    ]
    ++ (with python3Packages; [
      aiohttp
      aiohttp-openmetrics
      beautifulsoup4
      jinja2
      slixmpp
      prometheus-client
      pyyaml
    ]);

  nativeCheckInputs = with python3Packages; [
    setuptools
    unittestCheckHook
    pytz
  ];

  pythonImportsCheck = [ "prometheus_xmpp" ];

  passthru.tests = {
    binaryWorks = runCommand "${pname}-binary-test" { } ''
      # Running with --help to avoid it erroring due to a missing config file
      ${prometheus-xmpp-alerts}/bin/prometheus-xmpp-alerts --help | tee $out
      grep "usage: prometheus-xmpp-alerts" $out
    '';
  };

  meta = {
    description = "XMPP Web hook for Prometheus";
    mainProgram = "prometheus-xmpp-alerts";
    homepage = "https://github.com/jelmer/prometheus-xmpp-alerts";
    maintainers = with lib.maintainers; [ fpletz ];
    license = with lib.licenses; [ asl20 ];
  };
}
