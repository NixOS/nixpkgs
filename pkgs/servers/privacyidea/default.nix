{ stdenv, fetchgit, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "privacyidea-${version}";
  version = "2.14";

  src = fetchgit {
    url = "https://github.com/privacyidea/privacyidea.git";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    sha256 = "0aslidkf2q3hplypdf6abp4k8ln87db4xh47linx34bp0ygms57h";
  };

  postPatch = ''
    substituteInPlace privacyidea/api/lib/utils.py \
      --replace 'import pkg_resources' '# no pkg_resources' \
      --replace 'pkg_resources.get_distribution("privacyidea").version' \
                '"${version}"'
  '';

  postInstall = ''
    substituteInPlace $out/etc/privacyidea/privacyideaapp.wsgi \
      --replace '"/etc/privacyidea/pi.cfg"' 'sys.argv[1]'
  '';

  buildInputs = with pythonPackages; [ docutils ];
  propagatedBuildInputs = with pythonPackages; [
    pyusb pyasn1 pyyaml flask_sqlalchemy pillow flask_script python-gnupg
    funcparserlib pyopenssl passlib beautifulsoup4 flask_migrate lxml
    requests2 netaddr configobj pyjwt_1_3 ldap3 pygments pymysql sqlsoup
    argparse bcrypt pyrad qrcode psycopg2 matplotlib
  ];
}
