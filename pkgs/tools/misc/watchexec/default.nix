{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "03s9nsss4895x4lp90y65jajavk8c2nj1jjnmx0vbbwl210ghlv1";
  };

  cargoSha256 = "0p20d7paiafvl4k9iiazbgq75wk7k42sz2h1y5lalq16f5rp6dbp";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = https://github.com/watchexec/watchexec;
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
