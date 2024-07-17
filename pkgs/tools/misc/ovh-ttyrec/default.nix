{
  lib,
  stdenv,
  fetchFromGitHub,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "ovh-ttyrec";
  version = "1.1.7.1";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "ovh-ttyrec";
    rev = "v${version}";
    sha256 = "sha256-VTF9WLwAIWWn+W0sLQaoFBFro+pSXKwcTO6q6MW6JD8=";
  };

  nativeBuildInputs = [ zstd ];

  installPhase = ''
    mkdir -p $out/{bin,man}
    cp ttytime ttyplay ttyrec $out/bin
    cp docs/*.1 $out/man
  '';

  meta = with lib; {
    homepage = "https://github.com/ovh/ovh-ttyrec/";
    description = "Terminal interaction recorder and player";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      chaduffy
      zimbatm
    ];
  };
}
