{ stdenv, pythonPackages, fetchFromGitHub, dialog }:

pythonPackages.buildPythonPackage rec {
  version = "0.1.1-corrected";
  name = "letsencrypt-${version}";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "letsencrypt";
    rev = "v${version}";
    sha256 = "1f94yg81vhcv42lxccwzcjjgiz2ik1al2hb456hpbmlsd9i99n81";
  };

  propagatedBuildInputs = with pythonPackages; [
    zope_interface zope_component six requests2 pytz pyopenssl psutil mock acme
    cryptography configobj pyRFC3339 python2-pythondialog parsedatetime ConfigArgParse
  ];
  buildInputs = with pythonPackages; [ nose dialog ];

  patchPhase = ''
    substituteInPlace letsencrypt/notify.py --replace "/usr/sbin/sendmail" "/var/setuid-wrappers/sendmail"
    substituteInPlace letsencrypt/le_util.py --replace "sw_vers" "/usr/bin/sw_vers"
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
