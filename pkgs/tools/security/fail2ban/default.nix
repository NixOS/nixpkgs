{ stdenv, fetchzip, python, pythonPackages, unzip, systemd, gamin }:

let version = "0.9.1"; in

pythonPackages.buildPythonPackage {
  name = "fail2ban-${version}";
  namePrefix = "";

  src = fetchzip {
    name   = "fail2ban-${version}-src";
    url    = "https://github.com/fail2ban/fail2ban/archive/${version}.tar.gz";
    sha256 = "111xvy2gxwn868kn0zy2fmdfa423z6fk57i7wsfrc0l74p1cdvs5";
  };

  buildInputs = [ unzip ];

  pythonPath = (stdenv.lib.optional stdenv.isLinux systemd)
    ++ [ python.modules.sqlite3 gamin ];

  preConfigure = ''
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

  preInstall = ''
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
    maintainers = with maintainers; [ eelco lovek323 ];
    platforms   = platforms.linux ++ platforms.darwin;
  };
}
