{ lib, stdenv, fetchFromGitHub, opencl-clhpp, ocl-icd }:

stdenv.mkDerivation {
  pname = "opencl-info";
  version = "unstable-2014-02-21";

  src = fetchFromGitHub {
    owner = "marchv";
    repo = "opencl-info";
    rev = "3e53d001a98978feb865650cf0e93b045400c0d7";
    sha256 = "114lxgnjg40ivjjszkv4n3f3yq2lbrvywryvbazf20kqmdz7315l";
  };

  patches = [
    # The cl.hpp header was removed from opencl-clhpp. This patch
    # updates opencl-info to use the new cp2.hpp header.
    #
    # Submitted upstream: https://github.com/marchv/opencl-info/pull/2
    ./opencl-info-clhpp2.diff
  ];

  buildInputs = [ opencl-clhpp ocl-icd ];

  NIX_LDFLAGS = "-lOpenCL";

  installPhase = ''
    install -Dm755 opencl-info $out/bin/opencl-info
  '';

  meta = with lib; {
    description = "Tool to dump OpenCL platform/device information";
    homepage = "https://github.com/marchv/opencl-info";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "opencl-info";
  };
}
