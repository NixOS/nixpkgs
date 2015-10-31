{ stdenv, pythonPackages, fetchurl, dialog }:

let
  src = fetchurl {
    url = "https://github.com/letsencrypt/letsencrypt/archive/v${version}.tar.gz";
    sha256 = "1xr1ii2kfbhspyirwyqlk4vyx88irif92mw02jwfx9mnslk9gral";
  };
  version = "0.0.0.dev20151030";
  acme = pythonPackages.buildPythonPackage rec {
    name = "acme-${version}";
    inherit src version;

    propagatedBuildInputs = with pythonPackages; [
      cryptography pyasn1 pyopenssl pyRFC3339 pytz requests2 six werkzeug mock
      ndg-httpsclient
    ];

    buildInputs = with pythonPackages; [ nose ];

    sourceRoot = "letsencrypt-${version}/acme";
  };
in pythonPackages.buildPythonPackage rec {
  name = "letsencrypt-${version}";
  inherit src version;

  propagatedBuildInputs = with pythonPackages; [
    zope_interface zope_component six requests2 pytz pyopenssl psutil mock acme
    cryptography configobj pyRFC3339 python2-pythondialog parsedatetime ConfigArgParse
  ];
  buildInputs = with pythonPackages; [ nose dialog ];

  patchPhase = ''
    substituteInPlace letsencrypt/notify.py --replace "/usr/sbin/sendmail" "/var/setuid-wrappers/sendmail"
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram "$i" --prefix PYTHONPATH : "$PYTHONPATH" \
                       --prefix PATH : "${dialog}/bin:$PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/letsencrypt/letsencrypt;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = [ maintainers.iElectric ];
    license = licenses.asl20;
  };
}
