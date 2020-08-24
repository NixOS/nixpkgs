{ stdenv
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, installShellFiles
, ronn
, curl
, libgit2
, libssh2
, openssl
, Security
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-update";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "nabijaczleweli";
    repo = pname;
    rev = "v${version}";
    sha256 = "03yfn6jq33mykk2cicx54cpddilp62pb5ah75n96k1mwy7c46r6g";
  };

  cargoPatches = [ ./0001-Generate-lockfile-for-cargo-update-v4.1.1.patch ];
  cargoSha256 = "1yaawp015gdnlfqkdmqsf95gszz0h5j1vpfjh763y7kk0bp7zswl";

  nativeBuildInputs = [ cmake installShellFiles pkg-config ronn ];

  buildInputs = [ libgit2 libssh2 openssl zlib ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ curl Security ];

  postBuild = ''
    # Man pages contain non-ASCII, so explicitly set encoding to UTF-8.
    HOME=$TMPDIR \
    RUBYOPT="-E utf-8:utf-8" \
      ronn -r --organization="cargo-update developers" man/*.md
  '';

  postInstall = ''
    installManPage man/*.1
  '';

  meta = with stdenv.lib; {
    description = "A cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli filalex77 johntitor ];
  };
}
