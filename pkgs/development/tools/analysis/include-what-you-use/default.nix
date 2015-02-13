{ stdenv, fetchurl, cmake, llvmPackages }:

with llvmPackages;

let version = "3.5"; in
stdenv.mkDerivation rec {
  name = "include-what-you-use-${version}";

  src = fetchurl {
    sha256 = "1wfl78wkg8m2ssjnkb2rwcqy35nhc8fa63mk3sa60jrshpy7b15w";
    url = "${meta.homepage}/downloads/${name}.src.tar.gz";
  };

  meta = with stdenv.lib; {
    description = "Analyze #includes in C/C++ source files with clang";
    longDescription = ''
      For every symbol (type, function variable, or macro) that you use in
      foo.cc, either foo.cc or foo.h should #include a .h file that exports the
      declaration of that symbol. The include-what-you-use tool is a program
      that can be built with the clang libraries in order to analyze #includes
      of source files to find include-what-you-use violations, and suggest
      fixes for them. The main goal of include-what-you-use is to remove
      superfluous #includes. It does this both by figuring out what #includes
      are not actually needed for this file (for both .cc and .h files), and
      replacing #includes with forward-declares when possible.
    '';
    homepage = http://include-what-you-use.com;
    license = with licenses; bsd3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ clang cmake llvm ];

  cmakeFlags = [ "-DLLVM_PATH=${llvm}" ];
  enableParallelBuilding = true;
}
