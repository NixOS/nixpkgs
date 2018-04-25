{fetchurl, linkFarm}: rec {
  offline_cache = linkFarm "offline" packages;
  packages = [

    {
      name = "lockfile-1.0.0.tgz";
      path = fetchurl {
        name = "lockfile-1.0.0.tgz";
        url  = "https://registry.yarnpkg.com/@yarnpkg/lockfile/-/lockfile-1.0.0.tgz";
        sha1 = "33d1dbb659a23b81f87f048762b35a446172add3";
      };
    }

    {
      name = "docopt-0.6.2.tgz";
      path = fetchurl {
        name = "docopt-0.6.2.tgz";
        url  = "https://registry.yarnpkg.com/docopt/-/docopt-0.6.2.tgz";
        sha1 = "b28e9e2220da5ec49f7ea5bb24a47787405eeb11";
      };
    }
  ];
}
