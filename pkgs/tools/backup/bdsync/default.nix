{ lib, stdenv, fetchFromGitHub
, openssl
, pandoc
, which
}:

stdenv.mkDerivation rec {
  pname = "bdsync";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "rolffokkens";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kx422cp1bxr62i1mi7dzrpwmys1kdp865rcymdp4knb5rr5864k";
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

  meta = with lib; {
    description = "Fast block device synchronizing tool";
    homepage = "https://github.com/TargetHolding/bdsync";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jluttine ];
  };
}
