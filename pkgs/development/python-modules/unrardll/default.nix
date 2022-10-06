{ lib, stdenv, buildPythonPackage, fetchPypi, unrar }:

buildPythonPackage rec {
  pname = "unrardll";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8bebb480b96cd49d4290d814914f39cff75cf0fa0514c4790bb32b1757227c78";
  };

  buildInputs = [ unrar ];

  NIX_CFLAGS_LINK = lib.optionalString stdenv.isDarwin "-headerpad_max_install_names";

  postInstall = lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libunrar.so ${unrar}/lib/libunrar.so $out/lib/python*/site-packages/unrardll/unrar.*-darwin.so
    install_name_tool -change libunrar.so ${unrar}/lib/libunrar.so build/lib.*/unrardll/unrar.*-darwin.so
  '';

  pythonImportsCheck = [ "unrardll" ];

  meta = with lib; {
    description = "Wrap the Unrar DLL to enable unraring of files in python";
    homepage = "https://github.com/kovidgoyal/unrardll";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
