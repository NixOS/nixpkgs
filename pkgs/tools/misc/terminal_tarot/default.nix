{ stdenv
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "terminal_tarot";
  version = "v0.1.1";

  src = fetchFromGitHub {
    owner = "aswan89";
    repo = pname;
    rev = version;
    sha256 = "0s1ahv7904z7z9r062pfgx3dn9z31l4xxq1vpizib969mvvnfg13";
  };

  cargoSha256 = "1djdm8b4q4s17kvn6392qy1zgm4jz14jzijsc4z6xrrn4mhpayvc";

  meta = with stdenv.lib; {
    description = "Toy application for making tarot readings at the terminal, Written in Rust";
    homepage = "https://github.com/aswan89/terminal_tarot";
    license = licenses.gpl3;
    maintainers = with maintainers; [ maintainers.aswan89 ];
  };
}
