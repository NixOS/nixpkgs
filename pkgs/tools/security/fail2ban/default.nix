{ lib, stdenv, fetchFromGitHub
, python3
, fetchpatch
, installShellFiles
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fail2ban";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "fail2ban";
    repo = "fail2ban";
    rev = version;
    sha256 = "q4U9iWCa1zg8sA+6pPNejt6v/41WGIKN5wITJCrCqQE=";
  };

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ installShellFiles ];

  pythonPath = with python3.pkgs;
    lib.optionals stdenv.isLinux [
      systemd
      pyinotify
    ];

  patches = [
    # remove references to use_2to3, for setuptools>=58
    # has been merged into master, remove next release
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/5ac303df8a171f748330d4c645ccbf1c2c7f3497.patch";
      sha256 = "sha256-aozQJHwPcJTe/D/PLQzBk1YH3OAP6Qm7wO7cai5CVYI=";
    })
    # fix use of MutableMapping with Python >= 3.10
    # https://github.com/fail2ban/fail2ban/issues/3142
    (fetchpatch {
      url = "https://github.com/fail2ban/fail2ban/commit/294ec73f629d0e29cece3a1eb5dd60b6fccea41f.patch";
      sha256 = "sha256-Eimm4xjBDYNn5QdTyMqGgT5EXsZdd/txxcWJojXlsFE=";
    })
  ];

  preConfigure = ''
    # workaround for setuptools 58+
    # https://github.com/fail2ban/fail2ban/issues/3098
    patchShebangs fail2ban-2to3
    ./fail2ban-2to3

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
      rm -r "${sitePackages}/etc"

      installManPage man/*.[1-9]
    '' + lib.optionalString stdenv.isLinux ''
      # see https://github.com/NixOS/nixpkgs/issues/4968
      rm -r "${sitePackages}/usr"
    '';

  meta = with lib; {
    homepage = "https://www.fail2ban.org/";
    description = "A program that scans log files for repeated failing login attempts and bans IP addresses";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco lovek323 ];
    platforms = platforms.unix;
  };
}
