{ stdenv, pythonPackages, fetchFromGitHub, dialog }:

pythonPackages.buildPythonApplication rec {
  name = "letsencrypt-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "letsencrypt";
    rev = "v${version}";
    sha256 = "0r2wis48w5nailzp2d5brkh2f40al6sbz816xx0akh3ll0rl1hbv";
  };

  propagatedBuildInputs = with pythonPackages; [
    ConfigArgParse
    acme
    configobj
    cryptography
    parsedatetime
    psutil
    pyRFC3339
    pyopenssl
    python2-pythondialog
    pytz
    six
    zope_component
    zope_interface
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
