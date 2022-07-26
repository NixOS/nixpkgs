{ stdenv
, lib
, fetchFromGitHub
, python3Packages
, dnsmasq
, getent
, kmod
, lxc
, iproute2
, iptables
, nftables
, util-linux
, which
, xclip
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-Sf1rl8GCSTuneuYroGqsm9Aq2rBurpyswOrfCq2mWOs=";
  };

  propagatedBuildInputs = with python3Packages; [
    gbinder-python
    pyclip
    pygobject3
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;
  dontWrapPythonPrograms = true;

  installPhase = ''
    mkdir -p $out/${python3Packages.python.sitePackages}

    cp -ra tools $out/${python3Packages.python.sitePackages}/tools

    cp -ra data $out/${python3Packages.python.sitePackages}/data
    wrapProgram $out/${python3Packages.python.sitePackages}/data/scripts/waydroid-net.sh \
       --prefix PATH ":" ${lib.makeBinPath [ dnsmasq getent iproute2 iptables nftables ]}

    mkdir -p $out/share/waydroid/gbinder.d
    cp gbinder/anbox.conf $out/share/waydroid/gbinder.d/anbox.conf

    mkdir -p $out/share/applications
    ln -s $out/${python3Packages.python.sitePackages}/data/Waydroid.desktop $out/share/applications/Waydroid.desktop

    mkdir $out/bin
    cp -a waydroid.py $out/${python3Packages.python.sitePackages}/waydroid.py
    ln -s $out/${python3Packages.python.sitePackages}/waydroid.py $out/bin/waydroid

    wrapPythonProgramsIn $out/${python3Packages.python.sitePackages} "${lib.concatStringsSep " " [
      "$out"
      python3Packages.gbinder-python
      python3Packages.pygobject3
      python3Packages.pyclip
      kmod
      lxc
      util-linux
      which
      xclip
    ]}"
  '';

  meta = with lib; {
    description = "Waydroid is a container-based approach to boot a full Android system on a regular GNU/Linux system like Ubuntu";
    homepage = "https://github.com/waydroid/waydroid";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mcaju ];
  };
}
