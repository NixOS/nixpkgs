{ stdenv, fetchFromGitHub
, openssl
, pandoc
, which
}:

stdenv.mkDerivation rec {
  pname = "bdsync";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "TargetHolding";
    repo = pname;
    rev = "v${version}";
    sha256 = "11grdyc6fgw93jvj965awsycqw5qbzsdys7n8farqnmya8qv8gac";
  };

  nativeBuildInputs = [ pandoc which ];
  buildInputs = [ openssl ];

  postPatch = ''
    patchShebangs ./tests.sh
    patchShebangs ./tests/
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bdsync -t $out/bin/
    install -Dm644 bdsync.1 -t $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "Fast block device synchronizing tool";
    homepage = "https://github.com/TargetHolding/bdsync";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
