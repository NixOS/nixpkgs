{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "seafdav";
  version = "unstable-2021-05-09";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafdav";
    rev = "0f178088879a8d03c22d9a6b55e7e7ddc39a0c0c"; # using a fixed revision because upstream may re-tag releases :/
    sha256 = "1gpvmfamjbw90gh9njgmba58qnzxji1w1sra46spnhi9k778mds3";
  };

  doCheck = false; # disabled because it requires a ccnet environment


  propagatedBuildInputs = with python3.pkgs; [
    seaserv
    seafobj
    defusedxml
    pysearpc
    future
    gunicorn
    jinja2
    json5
    python-pam
    pyyaml
    six
    lxml
    sqlalchemy
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafdav";
    description = "WebDAV server for seafile";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pacman99 ];
  };
}
