{
  buildPythonPackage,
  fetchPypi,
  lib,
  python,
  stdenv,
  unzip,
}:

buildPythonPackage rec {
  pname = "verilogae";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    python = "cp311";
    abi = "cp311";
    platform = "manylinux_2_17_x86_64.manylinux2014_x86_64";
    format = "wheel";
    customPath = "aa/a6/9daea00745844faba44c2917c66838adfc315269f38518ecca49e6eb5fb5";
    sha256 = "QsEVq/4c44xCkovOhXOj8Zh6rp4Ipq+NGjbTW25Fd6E=";
  };

  format = "other";

  unpackPhase = ''
    mkdir -p $out/lib/python${python.libPrefix}/site-packages
    ${unzip}/bin/unzip $src -d $out/lib/python${python.libPrefix}/site-packages
  '';

  checkPhase = ''
    export LD_LIBRARY_PATH="${stdenv.cc.cc.lib}/lib:${LD_LIBRARY_PATH}"
    export PYTHONPATH="$out/lib/python${python.libPrefix}/site-packages:$PYTHONPATH"
  '';

  buildInputs = [
    stdenv.cc.cc.lib
    unzip
  ];

  LD_LIBRARY_PATH = "${stdenv.cc.cc.lib}/lib/";

  pythonImportsCheck = [ "verilogae" ];

  meta = {
    description = "Verilog-A tool useful for compact model parameter extraction";
    homepage = "https://man.sr.ht/~dspom/openvaf_doc/verilogae/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jasonodoom jleightcap ];
    platforms = lib.platforms.linux;
  };
}
