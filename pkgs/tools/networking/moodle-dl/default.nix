{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "moodle-dl";
  version = "2.1.2.5";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1gc4037dwyi48h4vi0bam23rr7pfyn6jrz334radz0r6rk94y8lz";
  };

  # nixpkgs (and the GitHub upstream for readchar) are missing 2.0.1
  postPatch = ''
    substituteInPlace setup.py --replace 'readchar>=2.0.1' 'readchar>=2.0.0'
  '';

  propagatedBuildInputs = with python3Packages; [
    sentry-sdk
    colorama
    readchar
    youtube-dl
    certifi
    html2text
    requests
    slixmpp
  ];

  meta = with lib; {
    homepage = "https://github.com/C0D3D3V/Moodle-Downloader-2";
    maintainers = [ maintainers.kmein ];
    description = "A Moodle downloader that downloads course content fast from Moodle";
    license = licenses.gpl3Plus;
  };
}
