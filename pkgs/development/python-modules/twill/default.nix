{ stdenv, buildPythonPackage, fetchurl, isPy3k, pythonPackages }:
buildPythonPackage rec {
  name = "twill-0.9.1";

  disabled = isPy3k;

  src = fetchurl {
    url    = "mirror://pypi/t/twill/${name}.tar.gz";
    sha256 = "0zmssp41cgb5sz1jym7rxy6mamb64dxq3wra1bn6snna9v653pyj";
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
