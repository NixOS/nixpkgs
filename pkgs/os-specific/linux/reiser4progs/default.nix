{stdenv, fetchurl, libaal}:

stdenv.mkDerivation {
  name = "reiser4progs-1.0.6";

  src = fetchurl {
    url = http://chichkin_i.zelnet.ru/namesys/reiser4progs-1.0.6.tar.gz;
    sha256 = "0x6m6px19hz54r8q4wwpf437qmqh44c5ddw9846isr64zs2rpld0";
  };

  buildInputs = [libaal];

  preInstall = ''
    substituteInPlace Makefile --replace ./run-ldconfig true
  '';

  meta = {
    homepage = http://www.namesys.com/;
    description = "Reiser4 utilities";
  };
}
