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
  version = "1.0.0";
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
            sha256 = "15ayil28p20wkgpwkr4mz0imjxnf049xx4117jspg1qkjg2bn1b2";
          };
          py3 = {
            url = tfurl "mac" "cpu" "py3-none-any" ;
            sha256 = "1ynyhbm7yrp421364s49a1r3p83zxy74iiy5c4hx2xm5c4gs29an";
          };
        };
        linux-x86_64.cpu = {
          py2 = {
            url = tfurl "linux" "cpu" "cp27-none-linux_x86_64";
            sha256 = "1hwhq1qhjrfkqfkxpsrq6mdmdibnqr3n7xvzkxp6gaqj73vn5ch2";
          };
          py3 = {
            url = tfurl "linux" "cpu" "cp35-cp35m-linux_x86_64";
            sha256 = "0jx2mmlw0nxah9l25r46i7diqiv31qcz7855n250lsxfwcppy7y3";
          };
        };
        linux-x86_64.cuda = {
          py2 = {
            url = tfurl "linux" "gpu" "cp27-none-linux_x86_64";
            sha256 = "0l8f71x3ama5a6idj05jrswlmp4yg37fxhz8lx2xmgk14aszbcy5";
          };
          py3 = {
            url = tfurl "linux" "gpu" "cp35-cp35m-linux_x86_64";
            sha256 = "12q7s0yk0h3r4glh0fhl1fcdx7jl8xikwwp04a1lcagasr51s36m";
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
    [ numpy six protobuf3_2 swig mock ]
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
    platforms = with platforms; if cudaSupport then linux else linux ++ darwin;
  };
}
