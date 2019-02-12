{ stdenv, fetchFromGitHub, makeWrapper, curl, bash, jq, youtube-dl, gnome3 }:

stdenv.mkDerivation rec {
  pname = "kodi-cli";
  version = "1.1.1";
  
  src = fetchFromGitHub {
    owner = "nawar";
    repo = pname;
    rev = version;
    sha256 = "0f9wdq2fg8hlpk3qbjfkb3imprxkvdrhxfkcvr3dwfma0j2yfwam";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a kodi-cli $out/bin
    wrapProgram $out/bin/kodi-cli --prefix PATH : ${stdenv.lib.makeBinPath [ curl bash ]}
    cp -a playlist_to_kodi $out/bin
    wrapProgram $out/bin/playlist_to_kodi --prefix PATH : ${stdenv.lib.makeBinPath [ curl bash gnome3.zenity jq youtube-dl ]}
  '';
  
  meta = with stdenv.lib; {
    homepage = https://github.com/nawar/kodi-cli;
    description = "Kodi/XBMC bash script to send Kodi commands using JSON RPC. It also allows sending YouTube videos to Kodi";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.pstn ];
 };
}
