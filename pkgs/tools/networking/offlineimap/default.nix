{ stdenv, fetchFromGitHub, python2Packages,
  asciidoc, cacert, libxml2, libxslt, docbook_xsl }:

python2Packages.buildPythonApplication rec {
  version = "7.2.4";
  pname = "offlineimap";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "0h5q5nk2p2vx86w6rrbs7v70h81dpqqr68x6l3klzl3m0yj9agb1";
  };

  postPatch = ''
    # Skip xmllint to stop failures due to no network access
    sed -i docs/Makefile -e "s|a2x -v -d |a2x -L -v -d |"

    # Provide CA certificates (Used when "sslcacertfile = OS-DEFAULT" is configured")
    sed -i offlineimap/utils/distro.py -e '/def get_os_sslcertfile():/a\ \ \ \ return "${cacert}/etc/ssl/certs/ca-bundle.crt"'
  '';

  doCheck = false;

  nativeBuildInputs = [ asciidoc libxml2 libxslt docbook_xsl ];
  propagatedBuildInputs = with python2Packages; [ six kerberos ];

  postInstall = ''
    make -C docs man
    install -D -m 644 docs/offlineimap.1 ''${!outputMan}/share/man/man1/offlineimap.1
    install -D -m 644 docs/offlineimapui.7 ''${!outputMan}/share/man/man7/offlineimapui.7
  '';

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = http://offlineimap.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [];
  };
}
