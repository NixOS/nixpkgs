{ autoconf, automake, flex, yacc, stdenv, kernel, fetchFromGitHub }:
let
  version = "1.0.beta1-9e810b1";
in stdenv.mkDerivation {
  name = "ply-${version}";
  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    flex
    yacc
    kernel
    stdenv.cc
  ];

  src = fetchFromGitHub {
    owner = "iovisor";
    repo = "ply";
    rev = "9e810b157ba079c32c430a7d4c6034826982056e";
    sha256 = "15cp6iczawaqlhsa0af6i37zn5iq53kh6ya8s2hzd018yd7mhg50";
  };

  preConfigure = "sh autogen.sh --prefix=$out";

  configureFlags = [
    "--with-kerneldir=${kernel.dev}"
  ];
}
