{ fetchFromGitHub, fetchgit, nixosTests }:

{
  qemu = {
    version = "7.1";
    src = fetchFromGitHub {
      owner = "open-power";
      repo = "skiboot";
      rev = "v7.1";
      hash = "sha256-G3NZDVGj/4Or3IgVazBYKZAQQaEr4MoMjytFBW/c774=";
    };

    outputs = [ "out" "test" ];
    postBuild = ''
      make test/hello_world/hello_kernel/hello_kernel
    '';
    postInstall = ''
      mkdir -p $test
      cp test/hello_world/hello_kernel/hello_kernel $test
    '';

    passthru.tests.qemu = nixosTests.skiboot;
    meta.homepage = "https://github.com/open-power/skiboot";
  };

  blackbird = {
    version = "04-16-2019";
    src = fetchgit {
      url = "https://git.raptorcs.com/git/blackbird-skiboot";
      rev = "852ac62f47cce2d442f9296641fcda9cfecce041";
      hash = "sha256-gJAladH4qpIqK0W40UlgWhMhJfIFEPokz2epnnMQ7IE=";
    };
    meta.homepage = "https://git.raptorcs.com/git/blackbird-skiboot";
  };

  talos = {
    version = "04-16-2019";
    src = fetchgit {
      url = "https://git.raptorcs.com/git/talos-skiboot";
      rev = "9858186353f2203fe477f316964e03609d12fd1d";
      hash = "sha256-+FWoKBWEganVA9CnMJ3yGgWLKdL0Oa+W9dWVcGC3qRQ=";
    };
    meta.homepage = "https://git.raptorcs.com/git/talos-skiboot";
  };
}

