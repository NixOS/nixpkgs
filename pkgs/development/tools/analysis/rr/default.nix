{ stdenv, fetchFromGitHub, cmake, libpfm, zlib, python }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "rr-${version}";
  version = "2.0.0-f2b02c4";

  src = fetchFromGitHub {
    owner  = "mozilla";
    repo   = "rr";
    rev    = "f2b02c4144584dec092d10eb42be2396069ea546";
    sha256 = "1vdhgh3bp287z21lxfj3rb9r3fbar18n9pl0v31h8axjn57l70h7";
  };

  buildInputs = [ cmake libpfm zlib python ];
  cmakeFlags =
      "-DCMAKE_C_FLAGS_RELEASE:STRING= -DCMAKE_CXX_FLAGS_RELEASE:STRING="
    + (optionalString (stdenv.system == "x86_64-linux") " -Dforce64bit=ON");

  meta = {
    homepage = http://rr-project.org/;
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license     = "custom";
    maintainers = with stdenv.lib.maintainers; [ pierron thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}