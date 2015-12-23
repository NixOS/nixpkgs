{ fetchurl, lib, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, sqlite3, darcsver, setuptoolsTrial, python
, setuptoolsDarcs, numpy, nettools, pycrypto, pyasn1, mock, zope_interface }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

buildPythonPackage rec {
  name = "tahoe-lafs-1.10.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://tahoe-lafs.org/source/tahoe-lafs/releases/allmydata-tahoe-1.10.0.tar.bz2";
    sha256 = "1qng7j1vykk8zl5da9yklkljvgxfnjky58gcay6dypz91xq1cmcw";
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
  buildInputs = [ unzip numpy ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs =
    [ twisted foolscap nevow simplejson zfec pycryptopp sqlite3
      darcsver setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 zope_interface mock
    ];

  postInstall = ''
    # Install the documentation.
    mkdir -p "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;
  '';

  checkPhase = ''
    # TODO: broken with wheels
    #${python.interpreter} setup.py trial
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
