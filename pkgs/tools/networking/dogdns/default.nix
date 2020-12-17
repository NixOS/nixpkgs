{ stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "dogdns";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "v${version}";
    sha256 = "088ib0sncv0vrvnqfvxf5zc79v7pnxd2cmgp4378r6pmgax9z9zy";
  };

  nativeBuildInputs = [ installShellFiles ]
    ++ stdenv.lib.optionals stdenv.isLinux [ pkg-config ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Security ];

  cargoSha256 = "08scc6vh703245rg3xkffhalrk5pisd0wg54fd49d7gdbyjivgi6";

  postInstall = ''
    installShellCompletion completions/dog.{bash,fish,zsh}
  '';

  meta = with stdenv.lib; {
    description = "Command-line DNS client";
    homepage = "https://dns.lookup.dog";
    license = licenses.eupl12;
    maintainers = with maintainers; [ bbigras ];
  };
}
