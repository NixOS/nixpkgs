{ fetchurl, lib, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, pysqlite, darcsver, setuptoolsTrial
, setuptoolsDarcs, numpy, nettools, pycrypto, pyasn1 }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

buildPythonPackage (rec {
  name = "tahoe-lafs-1.7.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://allmydata.org/source/tahoe/releases/allmydata-tahoe-1.7.1.zip";
    sha256 = "7e676e1ea517b3f6f6f76d56f712e72a5c2d4287fdd474abc9523aa533fd9038";
  };

  patches = [ ./test-timeout.patch ];

  configurePhase = ''
    echo "forcing the use of \`setuptools' 0.6c9 rather than an unreleased version"
    for i in *setup.py
    do
      sed -i "$i" -es'/0.6c12dev/0.6c9/g'
    done

    # `find_exe()' returns a list like ['.../bin/python'
    # '.../bin/twistd'], which doesn't work when `twistd' is not a
    # Python script (e.g., when it's a script produced by
    # `wrapProgram').
    sed -i "src/allmydata/scripts/startstop_node.py" \
        -es"|cmd = find_exe.find_exe('twistd')|cmd = ['${twisted}/bin/twistd']|g"

    sed -i "src/allmydata/util/iputil.py" \
        -es"|_linux_path = '/sbin/ifconfig'|_linux_path = '${nettools}/sbin/ifconfig'|g"

    # Chroots don't have /etc/hosts and /etc/resolv.conf, so work around
    # that.
    for i in $(find src/allmydata/test -type f)
    do
      sed -i "$i" -e"s/localhost/127.0.0.1/g"
    done
  '';

  buildInputs = [ unzip ]
    ++ [ numpy ]; # Some tests want this + http://tahoe-lafs.org/source/tahoe-lafs/deps/tahoe-dep-sdists/mock-0.6.0.tar.bz2

  # The `backup' command requires `pysqlite'.
  propagatedBuildInputs =
    [ twisted foolscap nevow simplejson zfec pycryptopp pysqlite
      darcsver setuptoolsTrial setuptoolsDarcs pycrypto pyasn1
    ];

  # The test suite is run in `postInstall'.
  doCheck = false;

  postInstall = ''
    # Install the documentation.

    # FIXME: Inkscape segfaults when run from here.  Setting $HOME to
    # something writable doesn't help; providing $FONTCONFIG_FILE doesn't
    # help either.  So we just don't run `make' under `docs/'.

    ensureDir "$out/share/doc/${name}"
    cp -rv "docs/"* "$out/share/doc/${name}"
    find "$out/share/doc/${name}" -name Makefile -exec rm -v {} \;

    # Run the tests once everything is installed.
    # FIXME: Some of the tests want to run $out/bin/tahoe, which isn't usable
    # yet because it gets wrapped later on, in `postFixup'.
    export PYTHON_EGG_CACHE="$TMPDIR"
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

    license = [ "GPLv2+" /* or */ "TGPPLv1+" ];

    maintainers = [ lib.maintainers.ludo lib.maintainers.simons  ];
    platforms = lib.platforms.gnu;  # arbitrary choice
  };
})
