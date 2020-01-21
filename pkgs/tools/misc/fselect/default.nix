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

  cargoSha256 = "1496zjrkwj5bv08k575m064x0hfk0gpci0dmxvvspj6jf8f8bfm6";

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
