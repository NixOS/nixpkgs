{ stdenv, fetchurl, jdk8 }:

stdenv.mkDerivation rec {
  version = "2.7.2";
  pname = "boot";

  src = fetchurl {
    url = "https://github.com/boot-clj/boot-bin/releases/download/${version}/boot.sh";
    sha256 = "1hqp3xxmsj5vkym0l3blhlaq9g3w0lhjgmp37g6y3rr741znkk8c";
  };

  inherit jdk8;

  builder = ./builder.sh;

  propagatedBuildInputs = [ jdk8 ];

  meta = with stdenv.lib; {
    description = "Build tooling for Clojure";
    homepage = "https://boot-clj.com/";
    license = licenses.epl10;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ragge ];
  };
}
