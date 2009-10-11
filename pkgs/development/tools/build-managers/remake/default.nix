{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "remake-3.81-dbg-0.2";
  src = fetchurl {
    url = mirror://sourceforge/bashdb/remake-3.81+dbg-0.2.tar.gz;
    sha256 = "0mhc06zgd39dl8rk16ii0m2x22b9zi67d48km7rn0fzzv519lmwc";
  };

  meta = {
    homepage = http://bashdb.sourceforge.net/remake/;
    license = "GPL";
    description = "GNU Make with comprehensible tracing and a debugger";
  };
}
