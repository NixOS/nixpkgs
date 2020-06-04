{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "vend";
  version = "unstable-2020-06-04";

  patches = [./remove_tidy.patch];

  # A permanent fork from master is maintained to avoid non deterministic go tidy
  src = fetchFromGitHub {
    owner = "c00w";
    repo = "vend";
    rev = "24fdebfdb2c3cc0516321a9cf33a3fd81c209c04";
    sha256 = "112p9dz9by2h2m3jha2bv1bvzn2a86bpg1wphgmf9gksjpwy835l";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage = "https://github.com/c00w/vend";
    description = "A utility which vendors go code including c dependencies";
    maintainers = with maintainers; [ c00w ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
