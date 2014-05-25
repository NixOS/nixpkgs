{ stdenv, fetchurl, unzip, cmake, libpfm }:

stdenv.mkDerivation rec {
  version = "1.3.0";
  name = "rr-${version}";

  src = fetchurl {
    url = "https://github.com/mozilla/rr/archive/${version}.zip";
    sha256 = "c7b7efac77f00805a26b0530e0bca4076b4b058374e5501328ec17cf0fa27021";
  };

  buildInputs = [ unzip cmake libpfm ];
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