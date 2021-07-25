{ coreutils, fetchFromGitHub, lib, makeWrapper, stdenv, util-linux, xauth, xorgserver }:

stdenv.mkDerivation rec {
  pname = "sx";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "earnestly";
    repo = pname;
    rev = version;
    sha256 = "0xv15m30nhcknasqiybj5wwf7l91q4a4jf6xind8x5x00c6br6nl";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/sx \
      --prefix PATH : ${lib.makeBinPath [ coreutils util-linux xorgserver xauth ]}
  '';

  meta = with lib; {
    description = "Simple alternative to both xinit and startx for starting a Xorg server";
    homepage = "https://github.com/earnestly/sx";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda ];
  };
}
