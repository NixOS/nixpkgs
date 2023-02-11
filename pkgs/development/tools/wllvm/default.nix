{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  version = "1.3.1";
  pname = "wllvm";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-PgV6V18FyezIZpqMQEbyv98MaVM7h7T7/Kvg3yMMwzE=";
  };

  meta = with lib; {
    homepage = "https://github.com/travitch/whole-program-llvm";
    description = "A wrapper script to build whole-program LLVM bitcode files";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 dtzWill ];
    platforms = platforms.all;
  };
}
