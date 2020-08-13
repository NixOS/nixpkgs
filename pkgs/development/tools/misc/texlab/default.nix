{ stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0iydkbmx9z7xpwaif0han5jvy9xh1afmfyldl7fcyy4r906dsmhx";
  };

  cargoSha256 = "0iibjh2ll181j69vld1awvjgyv3xwmq0abh10651la4k4jpppx46";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage texlab.1
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = "https://texlab.netlify.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
