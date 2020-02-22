{ buildGoModule, fetchFromGitHub, lib, wl-clipboard, makeWrapper }:

buildGoModule rec {
  pname = "clipman";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "yory8";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b27rgyjwvdm9qjq824imda3yjbxxcwwyv8rzzk95ggvyayxw8an";
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
