{ stdenv, fetchgit, libaio }:

stdenv.mkDerivation rec {
  name = "fio-2.0.8";
  
  src = fetchgit {
    url = git://git.kernel.dk/fio.git;
    rev = "cf9a74c8bd63d9db5256f1362885c740e11a1fe5";
    sha256 = "b34de480bbbb9cde221d0c4557ead91790feb825a1e31c4013e222ee7f43e937";
  };
  
  buildInputs = [ libaio ];

  installPhase = ''
    make install prefix=$out
  '';

  meta = {
    homepage = "http://git.kernel.dk/?p=fio.git;a=summary";
    description = "Flexible IO Tester - an IO benchmark tool";
    license = stdenv.lib.licenses.gpl2;
  };
}
