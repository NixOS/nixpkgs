{ stdenv, fetchFromGitHub, fetchpatch, python3, gamin }:

let version = "0.10.4"; in

python3.pkgs.buildPythonApplication {
  pname = "fail2ban";
  inherit version;

  src = fetchFromGitHub {
    owner  = "fail2ban";
    repo   = "fail2ban";
    rev    = version;
    sha256 = "07ik6rm856q0ic2r7vbg6j3hsdcdgkv44hh5ck0c2y21fqwrck3l";
  };

  patches = [
    # 0.10.3 supports Python 3 but somehow this got into the way
    # https://github.com/fail2ban/fail2ban/issues/2255
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/657b147c0d7830f3600f3dc7feaa4815a7e19fde.patch";
      sha256 = "1hrk2x7ssrfhab1wrjk5xw1sxhiv2735glfcp6qcj8x4dss3q7f7";
    })
  ];

  pythonPath = with python3.pkgs;
    stdenv.lib.optionals stdenv.isLinux [
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

  postInstall = let
    sitePackages = "$out/${python3.sitePackages}";
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
