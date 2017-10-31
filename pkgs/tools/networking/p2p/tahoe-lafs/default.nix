{ fetchurl, lib, unzip, nettools, pythonPackages }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

pythonPackages.buildPythonApplication rec {
  version = "1.12.1";
  name = "tahoe-lafs-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://tahoe-lafs.org/downloads/tahoe-lafs-${version}.tar.bz2";
    sha256 = "0x9f1kjym1188fp6l5sqy0zz8mdb4xw861bni2ccv26q482ynbks";
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

  buildInputs = with pythonPackages; [ unzip numpy mock ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs = with pythonPackages; [
    twisted foolscap nevow simplejson zfec pycryptopp darcsver
    setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 zope_interface
    service-identity pyyaml
  ];

  postInstall = ''
    # Install the documentation.
    mkdir -p "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;
  '';

  checkPhase = ''
    # Still broken. ~ C.
    #   trial allmydata
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
    platforms = lib.platforms.gnu;  # arbitrary choice
  };
}
