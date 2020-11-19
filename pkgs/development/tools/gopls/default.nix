{ stdenv, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.5.3";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "04dkrvk5190kyfa9swxpl0m3xq9g90qp8j7yxhi87wyb8giqbll2";
  };

  modRoot = "gopls";
  vendorSha256 = "0ml8n6qnq9nprn7kv138qy0i2q8qawzd0lhh3v2qw39j0aj5fb7z";

  doCheck = false;

  # Only build gopls, and not the integration tests or documentation generator.
  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
