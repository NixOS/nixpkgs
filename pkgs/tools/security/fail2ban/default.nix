{ stdenv, fetchFromGitHub, python, pythonPackages, gamin }:

let version = "0.10.2"; in

pythonPackages.buildPythonApplication {
  name = "fail2ban-${version}";

  src = fetchFromGitHub {
    owner  = "fail2ban";
    repo   = "fail2ban";
    rev    = version;
    sha256 = "1asn9gp0ybz6fak991vki9vln4ijramvr13rbwpxyj5wfmnh05r5";
  };

  propagatedBuildInputs = [ gamin ]
    ++ (stdenv.lib.optional stdenv.isLinux pythonPackages.systemd);

  preConfigure = ''
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail \
        --replace /usr/bin/whois whois
    done
  '';

  doCheck = false;

  preInstall = ''
    substituteInPlace setup.py --replace /usr/share/doc/ share/doc/
  
    # see https://github.com/NixOS/nixpkgs/issues/4968
    ${python}/bin/${python.executable} setup.py install_data --install-dir=$out --root=$out
  '';

  postInstall = let
    sitePackages = "$out/lib/${python.libPrefix}/site-packages";
  in ''
    # see https://github.com/NixOS/nixpkgs/issues/4968
    rm -rf ${sitePackages}/etc ${sitePackages}/usr ${sitePackages}/var;
  '';

  meta = with stdenv.lib; {
    homepage    = http://www.fail2ban.org/;
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 fpletz ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
