{ clang, lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.2.9";
  pname = "wllvm";
  name = "${pname}-${version}";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-gfP1MVE35gmW60M/prY79oFvPHGkmPU6G/KUg7EOWI0=";
  };

  checkInputs = [ clang ];
  installCheckPhase = ''
    LLVM_COMPILER=clang $out/bin/wllvm --version
  '';

  meta = with lib; {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
