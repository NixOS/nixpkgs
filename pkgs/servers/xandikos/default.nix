{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.0.11";
  name = "xandikos-${version}";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "0qkgcsj702g6aniawv1lya3qddbq9x67c4577klfzw7jk9kybqyc";
  };

  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    icalendar
    dulwich
    defusedxml
    jinja2
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/jelmer/xandikos;
    description = "Lightweight CalDAV/CardDAV server";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

