{ stdenv, fetchFromGitHub, pythonPackages,
  asciidoc, libxml2, libxslt, docbook_xml_xslt }:

pythonPackages.buildPythonApplication rec {
  version = "7.1.2";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1bvlbw3bsx3qs8np1qdqbhpdr9qykzsql9684gm7gg84gw51i667";
  };

  postPatch = ''
    # Skip xmllint to stop failures due to no network access
    sed -i docs/Makefile -e "s|a2x -v -d |a2x -L -v -d |"
  '';

  doCheck = false;

  nativeBuildInputs = [ asciidoc libxml2 libxslt docbook_xml_xslt ];
  propagatedBuildInputs = [ pythonPackages.six pythonPackages.kerberos ];

  postInstall = ''
    make -C docs man
    install -D -m 644 docs/offlineimap.1 ''${!outputMan}/share/man/man1/offlineimap.1
    install -D -m 644 docs/offlineimapui.7 ''${!outputMan}/share/man/man7/offlineimapui.7
  '';

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = http://offlineimap.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
