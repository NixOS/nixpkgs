{ stdenv, pythonPackages, fetchFromGitHub, dialog }:

pythonPackages.buildPythonApplication rec {
  name = "certbot-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    rev = "v${version}";
    sha256 = "1x0prlldkgg0hxmya4m5h3k3c872wr0jylmzpr3m04mk339yiw0c";
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
    substituteInPlace certbot/notify.py --replace "/usr/sbin/sendmail" "/var/setuid-wrappers/sendmail"
    substituteInPlace certbot/le_util.py --replace "sw_vers" "/usr/bin/sw_vers"
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
