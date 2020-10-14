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
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "nabijaczleweli";
    repo = pname;
    rev = "v${version}";
    sha256 = "0bpl4y5p0acn1clxgwn2sifx6ggpq9jqw5zrmva7asjf8p8dx3v5";
  };

  cargoPatches = [ ./0001-Generate-lockfile-for-cargo-update-v4.1.2.patch ];
  cargoSha256 = "150fpb7wyyxi40z4wai6c94mn84g700c2228316g6y8i07c8ix0d";

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
