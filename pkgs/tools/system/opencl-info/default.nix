{ stdenv, fetchFromGitHub, opencl-clhpp, ocl-icd }:

stdenv.mkDerivation {
  name = "opencl-info-2014-02-21";

  src = fetchFromGitHub {
    owner = "marchv";
    repo = "opencl-info";
    rev = "3e53d001a98978feb865650cf0e93b045400c0d7";
    sha256 = "114lxgnjg40ivjjszkv4n3f3yq2lbrvywryvbazf20kqmdz7315l";
  };

  buildInputs = [ opencl-clhpp ocl-icd ];

  NIX_LDFLAGS = "-lOpenCL";

  installPhase = ''
    install -Dm755 opencl-info $out/bin/opencl-info
  '';

  meta = with stdenv.lib; {
    description = "A tool to dump OpenCL platform/device information";
    homepage = https://github.com/marchv/opencl-info;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
