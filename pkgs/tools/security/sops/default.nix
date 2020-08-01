{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "01skk6vdfki4a88z0snl1pby09im406qhnsfa0d2l8gp6nz8pq6j";
  };

  vendorSha256 = "0475y95qma5m346ng898n80xv2rxzndx89c9ygjcvjs513yzcba2";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
