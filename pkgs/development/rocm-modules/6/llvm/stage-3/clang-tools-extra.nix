{ stdenv
, callPackage
, rocmUpdateScript
, llvm
, clang-unwrapped
, gtest
}:

callPackage ../base.nix rec {
  inherit stdenv rocmUpdateScript;
  buildTests = false; # `invalid operands to binary expression ('std::basic_stringstream<char>' and 'const llvm::StringRef')`
  targetName = "clang-tools-extra";

  targetProjects = [
    "clang"
    "clang-tools-extra"
  ];

  extraBuildInputs = [ gtest ];

  extraCMakeFlags = [
    "-DLLVM_INCLUDE_DOCS=OFF"
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DCLANG_INCLUDE_DOCS=OFF"
    "-DCLANG_INCLUDE_TESTS=ON"
    "-DCLANG_TOOLS_EXTRA_INCLUDE_DOCS=ON"
  ];

  extraPostInstall = ''
    # Remove LLVM and Clang
    for path in `find ${llvm} ${clang-unwrapped}`; do
      if [ $path != ${llvm} ] && [ $path != ${clang-unwrapped} ]; then
        rm -f $out''${path#${llvm}} $out''${path#${clang-unwrapped}} || true
      fi
    done

    # Cleanup empty directories
    find $out -type d -empty -delete
  '';

  requiredSystemFeatures = [ "big-parallel" ];
}
