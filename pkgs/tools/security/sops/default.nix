{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.4.0";

  src = fetchFromGitHub {
    rev = version;
    owner = "mozilla";
    repo = pname;
    sha256 = "1mrqf9xgv88v919x7gz9l1x70xwvp6cfz3zp9ip1nj2pzn6ixz3d";
  };

  modSha256 = "13ja8nxycmdjnrnsxdd1qs06x408aqr4im127a6y433pkx2dg7gc";

  meta = with stdenv.lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
