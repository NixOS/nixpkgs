{ stdenv
, buildPythonPackage
, fetchurl
, pyperclip
, urwid
}:

buildPythonPackage rec {
  version = "0.1.4";
  pname = "upass";

  src = fetchurl {
    url = "https://github.com/Kwpolska/upass/archive/v${version}.tar.gz";
    sha256 = "0f2lyi7xhvb60pvzx82dpc13ksdj5k92ww09czclkdz8k0dxa7hb";
  };

  propagatedBuildInputs = [ pyperclip urwid ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Console UI for pass";
    homepage = https://github.com/Kwpolska/upass;
    license = licenses.bsd3;
  };

}
