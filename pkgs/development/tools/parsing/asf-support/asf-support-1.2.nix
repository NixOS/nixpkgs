{stdenv, fetchurl, aterm, ptsupport}: derivation {
  name = "asf-support-1.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/asf-support/asf-support-1.2.tar.gz;
    md5 = "f32de4c97e62486b67e0af4408585980";
  };
  stdenv = stdenv;
  aterm = aterm;
  ptsupport = ptsupport;
}
