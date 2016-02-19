{ fetchurl, lib, unzip, nettools, pythonPackages }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

pythonPackages.buildPythonApplication rec {
  version = "1.10.2";
  name = "tahoe-lafs-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "http://tahoe-lafs.org/source/tahoe-lafs/releases/allmydata-tahoe-${version}.tar.bz2";
    sha256 = "1rvv0ik5biy7ji8pg56v0qycnggzr3k6dbg88n555nb6r4cxgmgy";
  };

  patchPhase = ''
    sed -i "src/allmydata/util/iputil.py" \
        -es"|_linux_path = '/sbin/ifconfig'|_linux_path = '${nettools}/bin/ifconfig'|g"

    # Chroots don't have /etc/hosts and /etc/resolv.conf, so work around
    # that.
    for i in $(find src/allmydata/test -type f)
    do
      sed -i "$i" -e"s/localhost/127.0.0.1/g"
    done

    sed -i 's/"zope.interface.*"/"zope.interface"/' src/allmydata/_auto_deps.py
    sed -i 's/"pycrypto.*"/"pycrypto"/' src/allmydata/_auto_deps.py
  '';

  # Some tests want this + http://tahoe-lafs.org/source/tahoe-lafs/deps/tahoe-dep-sdists/mock-0.6.0.tar.bz2
  buildInputs = with pythonPackages; [ unzip numpy mock ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs = with pythonPackages; [
    twisted foolscap nevow simplejson zfec pycryptopp sqlite3 darcsver
    setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 zope_interface
    service-identity
  ];

  postInstall = ''
    # Install the documentation.
    mkdir -p "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;
  '';

  checkPhase = ''
    # TODO: broken with wheels
    #${pythonPackages.python.interpreter} setup.py trial
  '';

  meta = {
    description = "Tahoe-LAFS, a decentralized, fault-tolerant, distributed storage system";
    longDescription = ''
      Tahoe-LAFS is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';
    homepage = http://allmydata.org/;
    license = [ lib.licenses.gpl2Plus /* or */ "TGPPLv1+" ];
    maintainers = [ lib.maintainers.simons ];
    platforms = lib.platforms.gnu;  # arbitrary choice
  };
}
