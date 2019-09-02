{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "sops";
  version = "3.3.1";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = pname;
    sha256 = "0jbrz3yz6cj08h8cx6y98m8r0lpclh9367cw5apy6w3v71i3svfi";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
