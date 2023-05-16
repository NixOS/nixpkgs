{ stdenv, lib, buildPythonPackage, fetchPypi, openssl, bzip2 }:

buildPythonPackage rec {
  pname = "zeroc-ice";
<<<<<<< HEAD
  version = "3.7.9.1";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-MOVsYfUq3n62hPEUIOGA75RviGofHcXaJKMnYERxg74=";
=======
  version = "3.7.9";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-q994axJexRU1SUlg9P71NvaZRpR9dj46GX85cbvMEy8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ openssl bzip2 ];

  pythonImportsCheck = [ "Ice" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://zeroc.com/";
    license = licenses.gpl2;
    description = "Comprehensive RPC framework with support for Python, C++, .NET, Java, JavaScript and more.";
    maintainers = with maintainers; [ abbradar ];
  };
}
