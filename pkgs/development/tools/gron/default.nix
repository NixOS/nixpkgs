{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gron-${version}";
  version = "0.6.0";

  owner = "tomnomnom";
  repo = "gron";
  goPackagePath = "github.com/${owner}/${repo}";

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    sha256 = "05f3w4zr15wd7xk75l12y5kip4gnv719a2x9w2hy23q3pnss9wk0";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
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
