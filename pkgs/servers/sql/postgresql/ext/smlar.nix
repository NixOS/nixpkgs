{
  fetchgit,
  lib,
  postgresql,
  postgresqlBuildExtension,
}:

postgresqlBuildExtension {
  pname = "smlar-unstable";
  version = "2021-11-08";

  src = fetchgit {
    url = "git://sigaev.ru/smlar.git";
    rev = "f2522d5f20a46a3605a761d34a3aefcdffb94e71";
    hash = "sha256-AC6w7uYw0OW70pQpWbK1A3rkCnMvTJzTCAdFiY3rO7A=";
  };

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    description = "Compute similary of any one-dimensional arrays";
    homepage = "http://sigaev.ru/git/gitweb.cgi?p=smlar.git";
    platforms = postgresql.meta.platforms;
    license = lib.licenses.bsd2;
    maintainers = [ ];
    # Broken with no upstream fix available.
    broken = lib.versionAtLeast postgresql.version "16";
  };
}
