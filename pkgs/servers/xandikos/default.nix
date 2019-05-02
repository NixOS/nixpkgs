{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "0.1.0";
  name = "xandikos-${version}";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "12r8fciid2qpqf054584ywwh49yddyhhpkpcm6jihzyr5y2r4kn1";
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

