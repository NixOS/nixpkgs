{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  plugincode,
  file,
  zlib,
}:
buildPythonPackage rec {
  pname = "typecode-libmagic";
  version = "1.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aboutcode-org";
    repo = "scancode-plugins";
    tag = "v${version}";
    hash = "sha256-5Wp2/yst+CscTYvVhlHu6pXjCHL4A4zYrciFly9+dFQ=";
  };

  sourceRoot = "${src.name}/builtins/typecode_libmagic-linux";

  propagatedBuildInputs = [ plugincode ];

  preBuild = ''
    pushd src/typecode_libmagic

    rm data/magic.mgc lib/libmagic.so lib/libz-lm539.so.1
    ln -s ${file}/share/misc/magic.mgc data/magic.mgc
    ln -s ${file}/lib/libmagic.so lib/libmagic.so
    ln -s ${zlib}/lib/libz.so lib/libz-lm539.so.1

    popd
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "typecode_libmagic" ];

  meta = with lib; {
    description = "ScanCode Toolkit plugin to provide pre-built binary libraries and utilities and their locations";
    homepage = "https://github.com/aboutcode-org/scancode-plugins/tree/main/builtins/typecode_libmagic-linux";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
