{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "17dz0qj2981plvzp72yisyrjnyz1sy3pqyvhx76ws2754vjgq4ra";
  };

  cargoSha256 = "19b05gx717xjg4arn4zgrqh7ckzgzx0ygg9gkfzsg7phz7f01626";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with stdenv.lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
