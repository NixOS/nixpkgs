{ stdenv, pythonPackages, fetchFromGitHub, llvmPackages }:

pythonPackages.buildPythonPackage rec {
  name = "cldoc-${version}";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "jessevdk";
    repo = "cldoc";
    rev = "v${version}";
    sha256 = "126p0ryzr9dpbpigpvs7bfl2fzyaqvsp9yr2022kf5p974cwkafw";
  };

  patches = [ ./find-libclang.patch ];

  propagatedBuildInputs = [
    pythonPackages.pyparsing1
    llvmPackages.clang-unwrapped
  ];

  postPatch = ''
    substituteInPlace "./cldoc/tree.py" \
      --replace "NIXOS_CLANG_SO" "${llvmPackages.clang-unwrapped}/lib/libclang.so"
  '';

  meta = with stdenv.lib; {
    description = "clang based documentation generator for C and C++";
    platforms = platforms.unix;
    homepage = https://jessevdk.github.io/cldoc/;
    license = licenses.gpl2;
    maintainers = [ maintainers.andrewrk ];
  };
}
