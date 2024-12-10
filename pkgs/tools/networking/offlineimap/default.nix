{
  lib,
  fetchFromGitHub,
  python3,
  asciidoc,
  cacert,
  docbook_xsl,
  installShellFiles,
  libxml2,
  libxslt,
  testers,
  offlineimap,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "offlineimap";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap3";
    rev = "v${version}";
    sha256 = "0y3giaz9i8vvczlxkbwymfkn3vi9fv599dy4pc2pn2afxsl4mg2w";
  };

  patches = [
    (fetchpatch {
      name = "sqlite-version-aware-threadsafety-check.patch";
      url = "https://github.com/OfflineIMAP/offlineimap3/pull/139/commits/7cd32cf834b34a3d4675b29bebcd32dc1e5ef128.patch";
      hash = "sha256-xNq4jFHMf9XZaa9BFF1lOzZrEGa5BEU8Dr+gMOBkJE4=";
    })
  ];

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certifi
    distro
    imaplib2
    pysocks
    rfc6555
    urllib3
  ];

  postPatch = ''
    # Skip xmllint to stop failures due to no network access
    sed -i docs/Makefile -e "s|a2x -v -d |a2x -L -v -d |"

    # Provide CA certificates (Used when "sslcacertfile = OS-DEFAULT" is configured")
    sed -i offlineimap/utils/distro_utils.py -e '/def get_os_sslcertfile():/a\ \ \ \ return "${cacert}/etc/ssl/certs/ca-bundle.crt"'
  '';

  postInstall = ''
    make -C docs man
    installManPage docs/offlineimap.1
    installManPage docs/offlineimapui.7
  '';

  # Test requires credentials
  doCheck = false;

  pythonImportsCheck = [
    "offlineimap"
  ];

  passthru.tests.version = testers.testVersion { package = offlineimap; };

  meta = with lib; {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    mainProgram = "offlineimap";
  };
}
