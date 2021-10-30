{ lib
, fetchFromGitHub
, python2Packages
, asciidoc
, cacert
, docbook_xsl
, installShellFiles
, libxml2
, libxslt
}:

python2Packages.buildPythonApplication rec {
  version = "7.3.4";
  pname = "offlineimap";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "sha256-sra2H0+5+LAIU3+uJnii+AYA05nuDyKVMW97rbaFOfI=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    installShellFiles
    libxml2
    libxslt
  ];

  propagatedBuildInputs = with python2Packages; [
    six
    kerberos
    rfc6555
    pysocks
  ];

  postPatch = ''
    # Skip xmllint to stop failures due to no network access
    sed -i docs/Makefile -e "s|a2x -v -d |a2x -L -v -d |"

    # Provide CA certificates (Used when "sslcacertfile = OS-DEFAULT" is configured")
    sed -i offlineimap/utils/distro.py -e '/def get_os_sslcertfile():/a\ \ \ \ return "${cacert}/etc/ssl/certs/ca-bundle.crt"'
  '';

  postInstall = ''
    make -C docs man
    installManPage docs/offlineimap.1
    installManPage docs/offlineimapui.7
  '';

  # Test requires credentials
  doCheck = false;

  meta = with lib; {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ endocrimes ];
  };
}
