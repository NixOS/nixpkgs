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
  version = "1.3.0";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-6osDGYyFuyPDeK1QFowh414j3laD8i4bqPgCeJmsszE=";
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
    make install DESTDIR=$out PREFIX= USE_SYSTEMD=0 USE_NFTABLES=1

    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
       --prefix PATH ":" ${lib.makeBinPath [ dnsmasq getent iproute2 nftables ]}

    wrapPythonProgramsIn $out/lib/waydroid/ "${lib.concatStringsSep " " [
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
