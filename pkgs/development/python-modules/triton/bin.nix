{ lib
, stdenv
, buildPythonPackage
, fetchurl
, isPy37
, isPy38
, isPy39
, isPy310
, isPy311
, python
, pythonOlder
, pythonAtLeast
, filelock
, lit
, pythonRelaxDepsHook
, zlib
}:

buildPythonPackage rec {
  pname = "triton";
  version = "2.0.0";
  format = "wheel";

  src =
    let pyVerNoDot = lib.replaceStrings [ "." ] [ "" ] python.pythonVersion;
        unsupported = throw "Unsupported system";
        srcs = (import ./binary-hashes.nix version)."${stdenv.system}-${pyVerNoDot}" or unsupported;
    in fetchurl srcs;

  disabled = !(isPy38 || isPy39 || isPy310 || isPy311);

  pythonRemoveDeps = [ "cmake" "torch" ];

  nativeBuildInputs = [
    pythonRelaxDepsHook # torch and triton refer to each other so this hook is included to mitigate that.
  ];

  propagatedBuildInputs = [
    filelock
    lit
    zlib
  ];

  dontStrip = true;

  postFixup = ''
    chmod +x "$out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      "$out/${python.sitePackages}/triton/third_party/cuda/bin/ptxas"
    patchelf --set-rpath "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}" \
      "$out/${python.sitePackages}/triton/_C/libtriton.so"
    patchelf --add-needed ${zlib.out}/lib/libz.so \
      "$out/${python.sitePackages}/triton/_C/libtriton.so"
  '';

  meta = with lib; {
    description = "A language and compiler for custom Deep Learning operations";
    homepage = "https://github.com/openai/triton/";
    changelog = "https://github.com/openai/triton/releases/tag/v${version}";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ junjihashimoto ];
  };
}
