{stdenv, fetchurl, aterm}: derivation {
  name = "toolbuslib-0.5.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.cwi.nl/projects/MetaEnv/toolbuslib/toolbuslib-0.5.1.tar.gz;
    md5 = "1c7c7cce870f813bef60bbffdf061c90";
  };
  stdenv = stdenv;
  aterm = aterm;
}
