{ lib, stdenv, fetchFromGitHub, python3 }:


python3.pkgs.buildPythonApplication rec {
  pname = "fail2ban";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    rev = version;
    sha256 = "q4U9iWCa1zg8sA+6pPNejt6v/41WGIKN5wITJCrCqQE=";
  };

  pythonPath = with python3.pkgs;
    lib.optionals stdenv.isLinux [
      systemd
    ];

  preConfigure = ''
    for i in config/action.d/sendmail*.conf; do
      substituteInPlace $i \
        --replace /usr/sbin/sendmail sendmail \
        --replace /usr/bin/whois whois
    done

    substituteInPlace config/filter.d/dovecot.conf \
      --replace dovecot.service dovecot2.service
  '';

  doCheck = false;

  preInstall = ''
    substituteInPlace setup.py --replace /usr/share/doc/ share/doc/

    # see https://github.com/NixOS/nixpkgs/issues/4968
    ${python3.interpreter} setup.py install_data --install-dir=$out --root=$out
  '';

  postPatch = ''
    ${stdenv.shell} ./fail2ban-2to3
  '';

  postInstall =
    let
      sitePackages = "$out/${python3.sitePackages}";
    in
    ''
      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -rf ${sitePackages}/etc ${sitePackages}/usr
    '';

  meta = with lib; {
    homepage = "https://www.fail2ban.org/";
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 fpletz ];
    platforms = platforms.unix;
  };
}
