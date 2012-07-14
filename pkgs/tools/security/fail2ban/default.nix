{ stdenv, fetchurl, pythonPackages, unzip, gamin }:

let version = "0.8.6"; in

pythonPackages.buildPythonPackage {
  name = "fail2ban-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/fail2ban/fail2ban/zipball/${version}";
    name = "fail2ban-${version}.zip";
    sha256 = "1linfz5qxmm4225lzi9vawsa79y41d3rcdahvrzlyqlhb02ipd55";
  };

  buildInputs = [ unzip ];

  pythonPath = [ gamin ];

  preConfigure =
    ''
      substituteInPlace setup.cfg \
        --replace /usr $out

      substituteInPlace setup.py \
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
  
  installCommand =
    ''
      python setup.py install --prefix=$out
    '';

  meta = {
    homepage = http://www.fail2ban.org/;
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
