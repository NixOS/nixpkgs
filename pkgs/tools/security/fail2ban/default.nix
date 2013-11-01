{ stdenv, fetchurl, pythonPackages, unzip, gamin }:

let version = "0.8.10"; in

pythonPackages.buildPythonPackage {
  name = "fail2ban-${version}";
  namePrefix = "";

  src = fetchurl {
    url    = "https://github.com/fail2ban/fail2ban/zipball/${version}";
    name   = "fail2ban-${version}.zip";
    sha256 = "0zbjwnghpdnzan7hn40cjjh2r06p2ph5kblpm0w1r72djwsk67x9";
  };

  buildInputs = [ unzip ];

  pythonPath = [ gamin ];

  preConfigure = ''
    substituteInPlace setup.cfg \
      --replace /usr $out

    substituteInPlace setup.py \
      --replace /usr $out \
      --replace /etc $out/etc \
      --replace /var $TMPDIR/var \

    for i in fail2ban-client fail2ban-regex fail2ban-server; do
      substituteInPlace $i \
        --replace /usr/share/fail2ban $out/share/fail2ban
    done

    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail \
        --replace /usr/bin/whois whois
    done
  '';

  doCheck = false;

  installCommand = ''
    python setup.py install --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.fail2ban.org/;
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 ];
    platforms   = platforms.unix;
  };
}
