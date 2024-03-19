{ fetchFromGitHub
, freerdp
, nmap
, openvpn
, python3Packages
, lib
, tigervnc
}:

python3Packages.buildPythonApplication rec {
  pname = "crowbar";
  version = "unstable-2020-04-23";

  src = fetchFromGitHub {
    owner = "galkan";
    repo = pname;
    rev = "500d633ff5ddfcbc70eb6d0b4d2181e5b8d3c535";
    sha256 = "05m9vywr9976pc7il0ak8nl26mklzxlcqx0p8rlfyx1q766myqzf";
  };

  propagatedBuildInputs = [ python3Packages.paramiko ];

  patchPhase = ''
    sed -i 's,/usr/bin/xfreerdp,${freerdp}/bin/xfreerdp,g' lib/main.py
    sed -i 's,/usr/bin/vncviewer,${tigervnc}/bin/vncviewer,g' lib/main.py
    sed -i 's,/usr/sbin/openvpn,${openvpn}/bin/openvpn,g' lib/main.py

    sed -i 's,/usr/bin/nmap,${nmap}/bin/nmap,g' lib/nmap.py
  '';

  # Sanity check
  checkPhase = ''
    $out/bin/crowbar --help > /dev/null
  '';

  meta = with lib; {
    homepage = "https://github.com/galkan/crowbar";
    description = "A brute forcing tool that can be used during penetration tests";
    mainProgram = "crowbar";
    license = licenses.mit;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
