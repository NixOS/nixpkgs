{ stdenv, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lpwp5fzlf037bn03x1dldw8nfa5pyqi4qsqbscwn42idvs94mhx";
  };

  cargoSha256 = "1g5k6dkv0zznh8q359n7sg9wf0gcix6m36pg9ql8wi5hnlsvg1s1";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ libxcb ];

  postInstall = ''
    install -D man/kmon.8 -t $out/share/man/man8/
  '';

  meta = with stdenv.lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
