{ stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0b6ichf528v9mca67301ncm808mzbdi212j0b8zz72aw8dff6ph2";
  };

  cargoSha256 = "13812swawp65f4j0c0q9x5bs9s3qancw0q2awasry0pcyh7nrxrj";

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
