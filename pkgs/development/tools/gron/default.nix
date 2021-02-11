{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gron";
  version = "0.6.1";

  owner = "tomnomnom";
  repo = "gron";
  goPackagePath = "github.com/${owner}/${repo}";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    sha256 = "0qmzawkhg0qn9kxxrssbdjni2khvamhrcklv3yxc0ljmh77mh61m";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Make JSON greppable!";
    longDescription = ''
      gron transforms JSON into discrete assignments to make it easier to grep
      for what you want and see the absolute 'path' to it. It eases the
      exploration of APIs that return large blobs of JSON but have terrible
      documentation.
    '';
    homepage = "https://github.com/tomnomnom/gron";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = with platforms; linux ++ darwin;
  };
}
