{ stdenv, buildGoModule, fetchgit }:

buildGoModule {
  pname = "goproxy";
  version = "unstable-2020-08-02";

  src = fetchgit {
    url = "https://git.sr.ht/~c00w/tooling";
    rev = "b7d8a852aeed9789dcc6a8920dc23c159fa6e02f";
    sha256 = "1jdcpyw889a90y51mnh7cl4izlidgypa926q3wh4x19hkm9vyy42";
  } + "/goproxy";

  vendorSha256 = null;

  meta = with stdenv.lib; {
    homepage = "https://git.sr.ht/~c00w/tooling";
    description = "Serves a go folder as a goproxy";
    maintainers = with maintainers; [ c00w ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
