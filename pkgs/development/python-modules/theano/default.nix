{ lib, stdenv
, runCommandCC
, fetchPypi
, buildPythonPackage
, isPyPy
, pythonOlder
, isPy3k
, nose
, numpy
, scipy
, setuptools
, six
, libgpuarray
, config
, cudaSupport ? config.cudaSupport, cudaPackages ? { }
, cudnnSupport ? cudaSupport
}:

let
  inherit (cudaPackages) cudatoolkit cudnn;
in

assert cudnnSupport -> cudaSupport;

let
  wrapped = command: buildTop: buildInputs:
    runCommandCC "${command}-wrapped" { inherit buildInputs; } ''
      type -P '${command}' || { echo '${command}: not found'; exit 1; }
      cat > "$out" <<EOF
      #!$(type -P bash)
      $(declare -xp | sed -e '/^[^=]\+="\('"''${NIX_STORE//\//\\/}"'\|[^\/]\)/!d')
      declare -x NIX_BUILD_TOP="${buildTop}"
      $(type -P '${command}') "\$@"
      EOF
      chmod +x "$out"
    '';

  # Theano spews warnings and disabled flags if the compiler isn't named g++
  cxx_compiler_name =
    if stdenv.cc.isGNU then "g++" else
    if stdenv.cc.isClang then "clang++" else
    throw "Unknown C++ compiler";
  cxx_compiler = wrapped cxx_compiler_name "\\$HOME/.theano"
    (    lib.optional cudaSupport libgpuarray_
      ++ lib.optional cudnnSupport cudnn );

  # We need to be careful with overriding Python packages within the package set
  # as this can lead to collisions!
  libgpuarray_ = libgpuarray.override { inherit cudaSupport cudaPackages; };

in buildPythonPackage rec {
  pname = "theano";
  version = "1.0.5";
  format = "setuptools";

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchPypi {
    inherit pname version;
    sha256 = "129f43ww2a6badfdr6b88kzjzz2b0wk0dwkvwb55z6dsagfkk53f";
  };

  postPatch = ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(param, is_valid=warn_cxx)' 'StrParam('\'''${cxx_compiler}'\''', is_valid=warn_cxx)' \
      --replace 'rc == 0 and config.cxx != ""' 'config.cxx != ""'
  '' + lib.optionalString cudaSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(get_cuda_root)' 'StrParam('\'''${cudatoolkit}'\''')'
  '' + lib.optionalString cudnnSupport ''
    substituteInPlace theano/configdefaults.py \
      --replace 'StrParam(default_dnn_base_path)' 'StrParam('\'''${cudnn}'\''')'
  '';

  # needs to be postFixup so it runs before pythonImportsCheck even when
  # doCheck = false (meaning preCheck would be disabled)
  postFixup = ''
    mkdir -p check-phase
    export HOME=$(pwd)/check-phase
  '';
  doCheck = false;
  # takes far too long, also throws "TypeError: sort() missing 1 required positional argument: 'a'"
  # when run from the installer, and testing with Python 3.5 hits github.com/Theano/Theano/issues/4276,
  # the fix for which hasn't been merged yet.

  # keep Nose around since running the tests by hand is possible from Python or bash
  nativeCheckInputs = [ nose ];
  # setuptools needed for cuda support
  propagatedBuildInputs = [
    libgpuarray_
    numpy
    numpy.blas
    scipy
    setuptools
    six
  ];

  pythonImportsCheck = [ "theano" ];

  meta = with lib; {
    homepage = "https://github.com/Theano/Theano";
    description = "A Python library for large-scale array computation";
    license = licenses.bsd3;
    maintainers = [ ];
    broken = true;
  };
}
