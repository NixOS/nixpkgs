{ lib
, buildPythonApplication
, fetchFromGitHub
, ConfigArgParse, acme, configobj, cryptography, distro, josepy, parsedatetime, pyRFC3339, pyopenssl, pytz, requests, six, zope_component, zope_interface
, dialog, mock, gnureadline
, pytest_xdist, pytest, dateutil
}:

buildPythonApplication rec {
  pname = "certbot";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1y0m5qm853i6pcpb2mrf8kjkr9wr80mdrx1qmck38ayvr2v2p5lc";
  };

  propagatedBuildInputs = [
    ConfigArgParse
    acme
    configobj
    cryptography
    distro
    josepy
    parsedatetime
    pyRFC3339
    pyopenssl
    pytz
    requests
    six
    zope_component
    zope_interface
  ];

  buildInputs = [ dialog mock gnureadline ];

  checkInputs = [ pytest_xdist pytest dateutil ];

  preBuild = ''
    cd certbot
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram "$i" --prefix PYTHONPATH : "$PYTHONPATH" \
                       --prefix PATH : "${dialog}/bin:$PATH"
    done
  '';

  doCheck = true;

  meta = with lib; {
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
    license = with licenses; [ asl20 ];
  };
}
