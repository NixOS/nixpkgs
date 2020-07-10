{ stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tunnelto";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "agrinman";
    repo = pname;
    rev = version;
    sha256 = "11v06w0mq9l6rcgbm0wx47a5x3n7js8f07g43xfjv0qf0ra4w2xj";
  };

  cargoSha256 = "0pq0ril8lm6y8pz0jj49zwcbb1yw3hjbpk4m9vp1vfbj3hvjcbp3";

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
