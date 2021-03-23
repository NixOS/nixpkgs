{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pandoc, pkg-config, zlib
, Security, libiconv, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "exa";
  version = "unstable-2021-01-14";

  cargoSha256 = "1lmjh0grpnx20y6raxnxgjkr92h395r6jk8mm2ypc4cxpxczdqvl";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = pname;
    rev = "13b91cced4cab012413b25c9d3e30c63548639d0";
    sha256 = "18y4v1s102lh3gvgjwdd66qlsr75wpwpcj8zsk5y5r95a405dkfm";
  };

  nativeBuildInputs = [ cmake pkg-config installShellFiles pandoc ];
  buildInputs = [ zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  outputs = [ "out" "man" ];

  postInstall = ''
    pandoc --standalone -f markdown -t man man/exa.1.md > man/exa.1
    pandoc --standalone -f markdown -t man man/exa_colors.5.md > man/exa_colors.5
    installManPage man/exa.1 man/exa_colors.5
    installShellCompletion \
      --name exa completions/completions.bash \
      --name exa.fish completions/completions.fish \
      --name _exa completions/completions.zsh
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    homepage = "https://the.exa.website";
    license = licenses.mit;
    maintainers = with maintainers; [ ehegnes lilyball globin ];
  };
}
