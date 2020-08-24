{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kgbqxw92ffvq8aws0rljarzsfxs8hdi8k37zx964fvigcdhrqba";
  };

  vendorSha256 = "1pyik8d1syjvwvkp7i94z1jmflw01wqpafmn1hsnbn034z4ygimd";

  meta = with stdenv.lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
  };
}
