{ stdenv, fetchFromGitHub, cmake, libpfm, zlib }:

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "rr-${version}";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "rr";
    rev = version;
    sha256 = "0mlxkj35zmm15dgnc7rfynnh2s2hpym01147vwc8pwv8qgab903s";
  };

  buildInputs = [ cmake libpfm zlib ];
  cmakeFlags = "-DCMAKE_C_FLAGS_RELEASE:STRING= -DCMAKE_CXX_FLAGS_RELEASE:STRING=";

  meta = {
    homepage = http://rr-project.org/;
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = "custom";
    maintainers = [ stdenv.lib.maintainers.pierron ];
    platforms = [ "i686-linux" ];
  };
}