{ lib
, fetchFromGitHub
, python3
, asciidoc
, cacert
, docbook_xsl
, installShellFiles
, libxml2
, libxslt
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

  meta = with lib; {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ endocrimes ];
  };
}
