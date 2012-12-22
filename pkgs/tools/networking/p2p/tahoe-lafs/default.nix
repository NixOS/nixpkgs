{ fetchurl, lib, unzip, buildPythonPackage, twisted, foolscap, nevow
, simplejson, zfec, pycryptopp, pysqlite, darcsver, setuptoolsTrial
, setuptoolsDarcs, numpy, nettools, pycrypto, pyasn1, mock }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

let
  name = "tahoe-lafs-1.8.3";
in
buildPythonPackage {
  inherit name;
  namePrefix = "";

  src = fetchurl {
    url = "http://tahoe-lafs.org/source/tahoe-lafs/snapshots/allmydata-tahoe-1.8.3.tar.bz2";
    sha256 = "00pm7fvwci5ncg2jhsqsl9r79kn495yni8nmr7p5i98f3siwvjd8";
  };

  # The patch doesn't apply cleanly to the current version.
  patches = [ /* ./test-timeout.patch */ ];

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
      darcsver setuptoolsTrial setuptoolsDarcs pycrypto pyasn1 mock
    ];

  # The test suite is run in `postInstall'.
  doCheck = false;

  postInstall = ''
    # Install the documentation.

    # FIXME: Inkscape segfaults when run from here.  Setting $HOME to
    # something writable doesn't help; providing $FONTCONFIG_FILE doesn't
    # help either.  So we just don't run `make' under `docs/'.

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

    license = [ "GPLv2+" /* or */ "TGPPLv1+" ];

    maintainers = [ lib.maintainers.ludo lib.maintainers.simons  ];
    platforms = lib.platforms.gnu;  # arbitrary choice
  };
}
