{ stdenv, pythonPackages, fetchFromGitHub, dialog }:

# Latest version of certbot supports python3 and python3 version of pythondialog

pythonPackages.buildPythonApplication rec {
  name = "certbot-${version}";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "certbot";
    repo = "certbot";
    rev = "v${version}";
    sha256 = "0gsq4si0bqwzd7ywf87y7bbprqg1m72qdj11h64qmwb5zl4vh444";
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
    substituteInPlace certbot/notify.py --replace "/usr/sbin/sendmail" "/run/wrappers/bin/sendmail"
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
    maintainers = [ maintainers.domenkozar ];
    license = licenses.asl20;
  };
}
