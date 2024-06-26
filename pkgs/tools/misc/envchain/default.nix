{
  lib,
  stdenv,
  fetchFromGitHub,
  libedit,
  libsecret,
  ncurses,
  pkg-config,
  readline,
  Security,
}:

stdenv.mkDerivation rec {
  pname = "envchain";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sorah";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QUy38kJzMbYOyT86as4/yq2ctcszSnB8a3eVWxgd4Fo=";
  };

  postPatch = ''
    sed -i -e "s|-ltermcap|-lncurses|" Makefile
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libsecret
      readline
    ]
    ++ lib.optionals stdenv.isDarwin [
      libedit
      ncurses
      Security
    ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Set environment variables with macOS keychain or D-Bus secret service";
    homepage = "https://github.com/sorah/envchain";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    mainProgram = "envchain";
  };
}
