{ lib, nettools, python3Packages, texinfo }:

# FAILURES: The "running build_ext" phase fails to compile Twisted
# plugins, because it tries to write them into Twisted's (immutable)
# store path. The problem appears to be non-fatal, but there's probably
# some loss of functionality because of it.

python3Packages.buildPythonApplication rec {
  pname = "tahoe-lafs";
  version = "1.17.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256:0whngh6j2k768kl70inrsn5l5r2mkw438fcmd7ygkr707w8grird";
  };

  outputs = [ "out" "doc" "info" ];

  patches = [ ./skip-tests.patch ];

  postPatch = ''
    # Chroots don't have /etc/hosts and /etc/resolv.conf, so work around
    # that.
    for i in $(find src/allmydata/test -type f)
    do
      sed -i "$i" -e"s/localhost/127.0.0.1/g"
    done
  '';

  # Remove broken and expensive tests.
  preConfigure = ''
    (
      cd src/allmydata/test

      # Buggy?
      rm cli/test_create.py test_client.py

      # These require Tor and I2P.
      rm test_connections.py test_iputil.py test_hung_server.py test_i2p_provider.py test_tor_provider.py

      # Expensive
      rm test_system.py
    )
  '';

  nativeBuildInputs = with python3Packages; [ sphinx texinfo ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs = with python3Packages; [
    attrs appdirs autobahn cbor2 characteristic collections-extended
    cryptography distro eliot fixtures foolscap future klein magic-wormhole
    netifaces pyasn1 pyutil pyyaml recommonmark service-identity simplejson
    six sphinx_rtd_theme testtools treq twisted zfec zope_interface
  ];

  checkInputs = with python3Packages; [
    beautifulsoup4 html5lib mock hypothesis twisted tenacity prometheus-client
  ];

  # Install the documentation.
  postInstall = ''
    (
      cd docs

      make singlehtml
      mkdir -p "$doc/share/doc/${pname}-${version}"
      cp -rv _build/singlehtml/* "$doc/share/doc/${pname}-${version}"

      make info
      mkdir -p "$info/share/info"
      cp -rv _build/texinfo/*.info "$info/share/info"
    )
  '';

  checkPhase = ''
    trial --rterrors --jobs $NIX_BUILD_CORES allmydata
  '';

  meta = with lib; {
    description = "Tahoe-LAFS, a decentralized, fault-tolerant, distributed storage system";
    longDescription = ''
      Tahoe-LAFS is a secure, decentralized, fault-tolerant filesystem.
      This filesystem is encrypted and spread over multiple peers in
      such a way that it remains available even when some of the peers
      are unavailable, malfunctioning, or malicious.
    '';
    homepage = "https://tahoe-lafs.org/";
    license = [ licenses.gpl2Plus /* or */ "TGPPLv1+" ];
    maintainers = with lib.maintainers; [ MostAwesomeDude exarkun ];
    platforms = platforms.gnu ++ platforms.linux;
  };
}
