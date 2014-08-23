{ fetchurl, lib, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, sqlite3, darcsver, setuptoolsTrial
, setuptoolsDarcs, numpy, nettools, pycrypto, pyasn1, mock }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

let
  name = "tahoe-lafs-1.10.0";
in
buildPythonPackage {
  inherit name;
  namePrefix = "";

  src = fetchurl {
    url = "http://tahoe-lafs.org/source/tahoe-lafs/releases/allmydata-tahoe-1.10.0.tar.bz2";
    sha256 = "1qng7j1vykk8zl5da9yklkljvgxfnjky58gcay6dypz91xq1cmcw";
  };

  configurePhase = ''
    sed -i "src/allmydata/util/iputil.py" \
        -es"|_linux_path = '/sbin/ifconfig'|_linux_path = '${nettools}/bin/ifconfig'|g"

    # Chroots don't have /etc/hosts and /etc/resolv.conf, so work around
    # that.
    for i in $(find src/allmydata/test -type f)
    do
      sed -i "$i" -e"s/localhost/127.0.0.1/g"
    done
  '';

  buildInputs = [ unzip ]
    ++ [ numpy ]; # Some tests want this + http://tahoe-lafs.org/source/tahoe-lafs/deps/tahoe-dep-sdists/mock-0.6.0.tar.bz2

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs =
    [ twisted foolscap nevow simplejson zfec pycryptopp sqlite3
      darcsver setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 mock
    ];

  # The test suite is run in `postInstall'.
  doCheck = false;

  postInstall = ''
    # Install the documentation.
    mkdir -p "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;

    # Run the tests once everything is installed.
    export PYTHON_EGG_CACHE="$TMPDIR"
    python setup.py build
    python setup.py trial
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

    # TODO license = [ lib.licenses.gpl2Plus /* or */ "TGPPLv1+" ];

    maintainers = [ lib.maintainers.simons  ];
    platforms = lib.platforms.gnu;  # arbitrary choice
  };
}
