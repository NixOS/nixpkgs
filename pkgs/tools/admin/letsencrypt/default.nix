{ stdenv, pythonPackages, fetchurl, dialog }:

pythonPackages.buildPythonPackage rec {
  version = "0.1.0";
  name = "letsencrypt-${version}";

  src = fetchurl {
    url = "https://github.com/letsencrypt/letsencrypt/archive/v${version}.tar.gz";
    sha256 = "056y5bsmpc4ya5xxals4ypzsm927j6n5kwby3bjc03sy3sscf6hw";
  };

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
