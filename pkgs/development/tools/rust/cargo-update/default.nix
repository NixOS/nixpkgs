{ lib, stdenv
, rustPlatform
, fetchCrate
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
  version = "12.0.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-01XtxPVYamXBwn4zwqiRvpD+mHjpIUp+JT0fu3+Peq8=";
  };

  cargoHash = "sha256-x7RK6Wix5TB5/Ff2qWis3HAhBReWekeoxjcFUv19oB4=";

  nativeBuildInputs = [ cmake installShellFiles pkg-config ronn ];

  buildInputs = [ libgit2 libssh2 openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ curl Security ];

  postBuild = ''
    # Man pages contain non-ASCII, so explicitly set encoding to UTF-8.
    HOME=$TMPDIR \
    RUBYOPT="-E utf-8:utf-8" \
      ronn -r --organization="cargo-update developers" man/*.md
  '';

  postInstall = ''
    installManPage man/*.1
  '';

  meta = with lib; {
    description = "A cargo subcommand for checking and applying updates to installed executables";
    homepage = "https://github.com/nabijaczleweli/cargo-update";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli Br1ght0ne johntitor ];
  };
}
