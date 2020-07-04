{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1idyr3h9dhb67xlhd5bsa7866i75w4jzjbbchq6fd9lqd488bsj7";
  };

  cargoSha256 = "14lkvfr1yz8g15ffc8j1vvy7q1nwqbkhz2y0fnskwqfzpd17f9gl";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ CoreServices ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with stdenv.lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://github.com/watchexec/watchexec";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
