{ stdenv, fetchFromGitHub, rustPlatform, cmake, perl, pkgconfig, zlib
, darwin, libiconv, installShellFiles
}:

with rustPlatform;

buildRustPackage rec {
  pname = "exa";
  version = "0.9.0";

  cargoSha256 = "1hgjp23rjd90wyf0nq6d5akjxdfjlaps54dv23zgwjvkhw24fidf";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "exa";
    rev = "v${version}";
    sha256 = "14qlm9zb9v22hxbbi833xaq2b7qsxnmh15s317200vz5f1305hhw";
  };

  nativeBuildInputs = [ cmake pkgconfig perl installShellFiles ];
  buildInputs = [ zlib ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security ]
  ;

  outputs = [ "out" "man" ];

  postInstall = ''
    installManPage contrib/man/exa.1
    installShellCompletion \
      --name exa contrib/completions.bash \
      --name exa.fish contrib/completions.fish \
      --name _exa contrib/completions.zsh
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = https://the.exa.website;
    license = licenses.mit;
    maintainers = with maintainers; [ ehegnes lilyball globin ];
  };
}
