{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "1zccl60l557lhaaqb33myys4vp3jsnjqh3dxb22i46bff28s1w6c";
  };

  cargoSha256 = "0023adx4xkm24p3nwj0j669xns4qf8insalcnlv3r2iv4138w10l";

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
