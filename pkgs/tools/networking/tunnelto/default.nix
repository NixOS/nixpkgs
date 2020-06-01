{ stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = version;
    sha256 = "0yigjg8kjl8v0636hjr3sg33p4v963vzq7wbfi986ymxfx47jqp7";
  };

  cargoSha256 = "0603b0hn84shl9wdg7zg7kf9050gh33d8ghscwsby1vqanakms9j";

  nativeBuildInputs = stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "Expose your local web server to the internet with a public URL";
    homepage = "https://tunnelto.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
