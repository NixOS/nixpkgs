{ stdenv, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "1g3n7ll0yg7w7hb3jgp25mlnqwsdzv0608f41z7q5gmsskdm3v1j";
  };

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  preInstall = ''
    install -Dm644 -t $out/share/mcfly mcfly.bash
  '';

  cargoSha256 = "0r2zb59rpja9z7q0gsylqaq4vqm5rp57fy56ajjrm6k6z06nq7bv";

  meta = with stdenv.lib; {
    homepage = https://github.com/cantino/mcfly;
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now.";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
