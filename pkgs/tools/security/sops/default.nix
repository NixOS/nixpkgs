{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "sops";
  version = "3.3.0";

  goPackagePath = "go.mozilla.org/sops";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = pname;
    sha256 = "0h02iy1dfn4874gyj3k07gbw8byb7rngvsi9kjglnad2pkf0pq2d";
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    license = licenses.mpl20;
  };
}
