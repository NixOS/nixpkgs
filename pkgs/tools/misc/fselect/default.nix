{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "1q7y5agsi6wjb1dnyvdhm4qmdhpv30cx5a8m1blks8is9z2bblz0";
  };

  cargoSha256 = "0r2zj0dvf6h4ph3b75z2rdlqwzkdjrjj2iad4dbf9nsr63giwd9n";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ filalex77 ];
  };
}
