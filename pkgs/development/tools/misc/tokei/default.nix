{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1c8m2arhy58ky8pzj0dp3w9gpacia9jwmayi0il640l4fm8nr734";
  };

  cargoSha256 = "1cl4fjbvrw7zhpb8rxj566ddlxbj9vdsb1cp7mh6llmvaia2vgks";

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
