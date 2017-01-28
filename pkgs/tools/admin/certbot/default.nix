{ stdenv, python2Packages, fetchFromGitHub, dialog }:

# Latest version of certbot supports python3 and python3 version of pythondialog

python2Packages.buildPythonApplication rec {
  name = "certbot-${version}";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    rev = "v${version}";
    sha256 = "0j3i6381nb7x6vysi12swvry31bpzj8lg7ikkb5c50bciwbyvwxp";
  };

  propagatedBuildInputs = with python2Packages; [
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
  buildInputs = [ dialog ] ++ (with python2Packages; [ nose mock gnureadline ]);

  patchPhase = ''
    substituteInPlace certbot/notify.py --replace "/usr/sbin/sendmail" "/var/setuid-wrappers/sendmail"
    substituteInPlace certbot/util.py --replace "sw_vers" "/usr/bin/sw_vers"
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
    maintainers = with maintainers; [ domenkozar pradeepchhetri ];
    license = licenses.asl20;
  };
}
