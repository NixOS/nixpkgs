{ stdenv
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "12r8fciid2qpqf054584ywwh49yddyhhpkpcm6jihzyr5y2r4kn1";
  };

  propagatedBuildInputs = with python3Packages; [
    dulwich
    defusedxml
    icalendar
    jinja2
  ];

  meta = with stdenv.lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers."0x4A6F" ];
  };
}

