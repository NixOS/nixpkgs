{ stdenv, fetchFromGitLab, python3 }:

python3.pkgs.buildPythonApplication rec {
  name = "hyperkitty-${version}";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "mailman";
    repo = "hyperkitty";
    rev = "v${version}";
    sha256 = "0xy883yn5mlpmkb1yxp942925zdbrzavayqg6a25w46c645a0r6l";
  };

  propagatedBuildInputs = with python3.pkgs; [
    robot-detection django_extensions rjsmin cssmin django-mailman3
    django-haystack lockfile networkx dateutil defusedxml
    django-paintstore djangorestframework django django-q
    django_compressor beautifulsoup4 # mailmanclient vcrpy mock
  ];

  buildInputs = with python3.pkgs; [ mock ];

  postPatch = ''
    sed -i 's/python-dateutil < 2.0/python-dateutil/' setup.py
    sed -i 's/Django<1.11/Django/' setup.py
    sed -i '/enum34/d' setup.py
  '';

  meta = {
    homepage = "http://www.gnu.org/software/mailman/";
    description = "Archiver for GNU Mailman v3";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.globin ];
  };
}
