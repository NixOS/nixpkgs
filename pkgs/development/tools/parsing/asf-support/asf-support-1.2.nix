{stdenv, fetchurl, aterm, ptsupport}:

stdenv.mkDerivation {
  name = "asf-support-1.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asf-support/asf-support-1.2.tar.gz;
    md5 = "f32de4c97e62486b67e0af4408585980";
  };
  inherit stdenv aterm ptsupport;
  buildInputs = [stdenv aterm ptsupport];
}
