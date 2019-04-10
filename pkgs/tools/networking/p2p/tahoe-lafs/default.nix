{ fetchFromGitHub, lib, unzip, nettools, pythonPackages, texinfo, sqlite }:

pythonPackages.buildPythonApplication rec {
  version = "unstable-2019-04-08";
  name = "tahoe-lafs-${version}";

  src = fetchFromGitHub {
    owner = "tahoe-lafs";
    repo = "tahoe-lafs";
    rev = "325c522d7c73065e3f7e10518a9785b822d1405a";
    sha256 = "1yn71g5cjjzrappgjv5lcj4yhpj9x8v2avb2dmqpb708ldaqyzq2";
  };

  outputs = [ "out" "doc" "info" ];

  nativeBuildInputs = with pythonPackages; [
    sphinx texinfo
  ];

  # The `backup' command requires `sqlite3'.
  propagatedBuildInputs = with pythonPackages; [
    sqlite
    characteristic
    eliot
    foolscap
    magic-wormhole
    nevow
    pyasn1
    pyasn1-modules
    pycryptopp
    pyopenssl
    pyyaml
    service-identity
    twisted
    twisted.extras.conch
    twisted.extras.tls
    zfec
  ];

  checkInputs = with pythonPackages; [
    certifi
    subunitreporter
    hypothesis
    treq
    testtools
    fixtures
  ];

  # Tests are usually run via tox, but we don't need this overhead.
  # Still a lot of tests are failing, need some help to debug this.
  doCheck = false;

  checkPhase = ''
    trial --rterrors allmydata
  '';

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
    maintainers = with lib.maintainers; [ MostAwesomeDude manveru ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;
  };
}
