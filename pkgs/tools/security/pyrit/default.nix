{ lib, fetchFromGitHub, python2Packages, openssl, zlib, libpcap, opencl-headers, ocl-icd }:

let
  version = "2019-12-13";
  src = fetchFromGitHub {
    owner = "JPaulMora";
    repo = "Pyrit";
    rev = "f0f1913c645b445dd391fb047b812b5ba511782c";
    sha256 = "1npkvngc4g3g6mpjip2wwhvcd4a75jy3dbddxhxhzrrz4p7259gr";
  };

  cpyrit_opencl = python2Packages.buildPythonPackage {
    pname = "cpyrit-opencl";
    inherit version;

    src = "${src}/modules/cpyrit_opencl";

    buildInputs = [ opencl-headers ocl-icd openssl zlib ];

    postInstall = let
      python = python2Packages.python;
    in ''
      # pyrit uses "import _cpyrit_cuda" so put the output in the root site-packages
      mv $out/lib/${python.libPrefix}/site-packages/cpyrit/_cpyrit_opencl.so $out/lib/${python.libPrefix}/site-packages/
    '';
  };
in
python2Packages.buildPythonApplication rec {
  pname = "pyrit";
  inherit version src;

  buildInputs = [ openssl zlib libpcap ];
  propagatedBuildInputs = [ cpyrit_opencl ];

  meta = with lib; {
    homepage = "https://github.com/JPaulMora/Pyrit";
    description = "GPGPU-driven WPA/WPA2-PSK key cracker";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
