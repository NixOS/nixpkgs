{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mdsh";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "mdsh";
    rev = "v${version}";
    sha256 = "1a9i6h8fzrrfzjyfxaps73lxgkz92k0bnmwbjbwdmiwci4qgi9ms";
  };

  cargoSha256 = "1bd3imalymbk6wpqs67i09gdj0vi3i6kkk6d00sw8svnv6fzmcis";
  verifyCargoDeps = true;

  meta = with stdenv.lib; {
    description = "Markdown shell pre-processor";
    homepage = https://github.com/zimbatm/mdsh;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ zimbatm ];
    platforms = platforms.all;
  };
}
