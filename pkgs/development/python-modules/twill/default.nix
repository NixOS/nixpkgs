{ stdenv, buildPythonPackage, fetchurl, isPy3k, pythonPackages }:
buildPythonPackage rec {
  pname = "twill";
  version = "1.8.0";
  name = "${pname}-${version}";

  disabled = isPy3k;

  src = fetchurl {
    url    = "mirror://pypi/t/twill/${name}.tar.gz";
    sha256 = "d63e8b09aa4f6645571c70cd3ba47a911abbae4d7baa4b38fc7eb72f6cfda188";
  };

  propagatedBuildInputs = with pythonPackages; [ nose ];

  doCheck = false; # pypi package comes without tests, other homepage does not provide all verisons

  meta = with stdenv.lib; {
    homepage = http://twill.idyll.org/;
    description = "a simple scripting language for Web browsing";
    license     = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mic92 ];
  };
}
