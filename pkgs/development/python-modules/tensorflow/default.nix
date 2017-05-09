{ stdenv
, fetchurl
, buildPythonPackage
, isPy35, isPy27
, cudaSupport ? false
, cudatoolkit ? null
, cudnn ? null
, gcc49 ? null
, linuxPackages ? null
, numpy
, six
, protobuf3_2
, swig
, werkzeug
, mock
, gcc
, zlib
}:

assert cudaSupport -> cudatoolkit != null
                   && cudnn != null
                   && gcc49 != null
                   && linuxPackages != null;

# unsupported combination
assert ! (stdenv.isDarwin && cudaSupport);

# tensorflow is built from a downloaded wheel, because the upstream
# project's build system is an arcane beast based on
# bazel. Untangling it and building the wheel from source is an open
# problem.

buildPythonPackage rec {
  pname = "tensorflow";
  version = "1.1.0";
  name = "${pname}-${version}";
  format = "wheel";
  disabled = ! (isPy35 || isPy27);

  src = let
      tfurl = sys: proc: pykind:
        let
          tfpref = if proc == "gpu"
            then "gpu/tensorflow_gpu"
            else "cpu/tensorflow";
        in
        "https://storage.googleapis.com/tensorflow/${sys}/${tfpref}-${version}-${pykind}.whl";
      dls =
        {
        darwin.cpu = {
          py2 = {
            url = tfurl "mac" "cpu" "py2-none-any" ;
            sha256 = "1fgf26lw0liqxc9pywc8y2mj8l1mv48nhkav0pag9vavdacb9mqr";
          };
          py3 = {
            url = tfurl "mac" "cpu" "py3-none-any" ;
            sha256 = "0z5p1fra7bih0vqn618i2w3vyy8d1rkc72k7bmjq0rw8msl717ia";
          };
        };
        linux-x86_64.cpu = {
          py2 = {
            url = tfurl "linux" "cpu" "cp27-none-linux_x86_64";
            sha256 = "0ld3hqx3idxk0zcrvn3p9yqnmx09zsj3mw66jlfw6fkv5hznx8j2";
          };
          py3 = {
            url = tfurl "linux" "cpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0ahz9222rzqrk43lb9w4m351klkm6mlnnvw8xfqip28vbmymw90b";
          };
        };
        linux-x86_64.cuda = {
          py2 = {
            url = tfurl "linux" "gpu" "cp27-none-linux_x86_64";
            sha256 = "1baa9jwr6f8f62dyx6isbw8yyrd0pi1dz1srjblfqsyk1x3pnfvh";
          };
          py3 = {
            url = tfurl "linux" "gpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0606m2awy0ifhniy8lsyhd0xc388dgrwksn87989xlgy90wpxi92";
          };
        };
      };
    in
    fetchurl (
      if stdenv.isDarwin then
        if isPy35 then
          dls.darwin.cpu.py3
        else
          dls.darwin.cpu.py2
      else if isPy35 then
        if cudaSupport then
          dls.linux-x86_64.cuda.py3
        else dls.linux-x86_64.cpu.py3
      else
        if cudaSupport then
          dls.linux-x86_64.cuda.py2
        else
          dls.linux-x86_64.cpu.py2
    );

  propagatedBuildInputs = with stdenv.lib;
    [ numpy six protobuf3_2 swig werkzeug mock ]
    ++ optionals cudaSupport [ cudatoolkit cudnn gcc49 ];

  # Note that we need to run *after* the fixup phase because the
  # libraries are loaded at runtime. If we run in preFixup then
  # patchelf --shrink-rpath will remove the cuda libraries.
  postFixup = let
    rpath = stdenv.lib.makeLibraryPath
      (if cudaSupport then
        [ gcc49.cc.lib zlib cudatoolkit cudnn
          linuxPackages.nvidia_x11 ]
      else
        [ gcc.cc.lib zlib ]
      );
  in
  ''
    find $out -name '*.so' -exec patchelf --set-rpath "${rpath}" {} \;
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "TensorFlow helps the tensors flow";
    homepage = http://tensorflow.org;
    license = licenses.asl20;
    maintainers = with maintainers; [ jpbernardy ];
    platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
  };
}
