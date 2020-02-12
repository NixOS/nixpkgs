{ buildGoModule, fetchFromGitHub, lib, wl-clipboard, makeWrapper }:

buildGoModule rec {
  pname = "clipman";
  version = "unstable-2019-12-10";

  src = fetchFromGitHub {
    owner = "yory8";
    repo = pname;
    rev = "c57453be90bb4496f67275db8c0beb2116a6ce14";
    sha256 = "0zvqk3gcpx67dsn7qr0p9bgjp0sljl3yrlsfbqzrbrmj2lwr98ys";
  };

  modSha256 = "0aw0ng8pk8qzn1iv79iw0v9zr8xdc8p9xnigr3ij86038f7aqdhv";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/clipman \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard ]}
  '';

  meta = with lib; {
    homepage = https://github.com/yory8/clipman;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ma27 ];
    description = "A simple clipboard manager for Wayland";
    platforms = platforms.linux;
  };
}
