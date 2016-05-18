{ stdenv, pythonPackages, fetchFromGitHub, dialog }:

pythonPackages.buildPythonApplication rec {
  name = "letsencrypt-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    rev = "v${version}";
    sha256 = "0x098cdyfgqvh7x5d3sz56qjpjyg5b4fl82086sm43d8mbz0h5rm";
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
  buildInputs = [ dialog ] ++ (with pythonPackages; [ nose mock gnureadline ]);

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
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = [ maintainers.domenkozar ];
    license = licenses.asl20;
  };
}
