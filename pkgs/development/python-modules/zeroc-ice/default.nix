{ stdenv, lib, buildPythonPackage, fetchPypi, openssl, bzip2, darwin, libiconv, Security }:

buildPythonPackage rec {
  pname = "zeroc-ice";
  version = "3.7.2";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1bs7h3k9nd1gls2azgp8gz9407cslxbi2x1gspab8p87a61pjim8";
  };

  buildInputs = [ openssl bzip2 ]
    ++ lib.optionals stdenv.isDarwin [ darwin.cctools libiconv Security ];

  postPatch = lib.optional stdenv.isDarwin ''
    sed -i '/xcrun/d' setup.py
  '';

  meta = with stdenv.lib; {
    homepage = https://zeroc.com/;
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
