{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  unrar,
}:

buildPythonPackage rec {
  pname = "unrardll";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4QZ/4nu03iBO+PNpLyPZPF07QpL3iyksb8fcT3V0n3Y=";
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
