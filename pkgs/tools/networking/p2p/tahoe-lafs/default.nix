{ fetchurl, lib, unzip, nettools, pythonPackages, texinfo }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

pythonPackages.buildPythonApplication rec {
  version = "1.13.0";
  name = "tahoe-lafs-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://tahoe-lafs.org/downloads/tahoe-lafs-${version}.tar.bz2";
    sha256 = "11pfz9yyy6qkkyi0kskxlbn2drfppx6yawqyv4kpkrkj4q7x5m42";
  };

  outputs = [ "out" "doc" "info" ];

  postPatch = ''
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

  # Remove broken and expensive tests.
  preConfigure = ''
    (
      cd src/allmydata/test

      # Buggy?
      rm cli/test_create.py test_backupdb.py

      # These require Tor and I2P.
      rm test_connections.py test_iputil.py test_hung_server.py test_i2p_provider.py test_tor_provider.py

      # Expensive
      rm test_system.py
    )
  '';

  nativeBuildInputs = with pythonPackages; [ sphinx texinfo ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs = with pythonPackages; [
    twisted foolscap nevow simplejson zfec pycryptopp darcsver
    setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 zope_interface
    service-identity pyyaml magic-wormhole treq
  ];

  checkInputs = with pythonPackages; [ mock hypothesis twisted ];

  # Install the documentation.
  postInstall = ''
    (
      cd docs

      make singlehtml
      mkdir -p "$doc/share/doc/${name}"
      cp -rv _build/singlehtml/* "$doc/share/doc/${name}"

      make info
      mkdir -p "$info/share/info"
      cp -rv _build/texinfo/*.info "$info/share/info"
    )
  '';

  checkPhase = ''
    trial --rterrors allmydata
  '';

  meta = {
    description = "Tahoe-LAFS, a decentralized, fault-tolerant, distributed storage system";
    longDescription = ''
      Tahoe-LAFS is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';
    homepage = http://tahoe-lafs.org/;
    license = [ lib.licenses.gpl2Plus /* or */ "TGPPLv1+" ];
    maintainers = with lib.maintainers; [ MostAwesomeDude ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
