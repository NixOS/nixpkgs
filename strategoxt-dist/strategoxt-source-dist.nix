{name, packagename, version, rev, url} :
{stdenv, fetchsvn, autotools, which, aterm, sdf}:
derivation {
  name        = name;
  packagename = packagename;
  rev         = rev;
  version     = version;

  system      = stdenv.system;
  builder     = ./build-from-svn.sh;
  src         = fetchsvn {url = url; rev = rev;};
  stdenv      = stdenv;

  make        = autotools.make;
  automake    = autotools.automake;
  autoconf    = autotools.autoconf;
  libtool     = autotools.libtool;
  which       = which;

  withaterm   = aterm;
  withsdf     = sdf;
}
