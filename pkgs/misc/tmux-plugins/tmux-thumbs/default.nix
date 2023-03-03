{ lib, mkTmuxPlugin, fetchFromGitHub, thumbs, substituteAll }:

mkTmuxPlugin rec {
  pluginName = "tmux-thumbs";
  version = "0.7.1";
  rtpFilePath = "tmux-thumbs.tmux";

  src = fetchFromGitHub {
    owner = "fcsonline";
    repo = pluginName;
    rev = version;
    sha256 = "sha256-PH1nscmVhxJFupS7dlbOb+qEwG/Pa/2P6XFIbR/cfaQ=";
  };

  patches = [
    (substituteAll {
      src = ./fix.patch;
      tmuxThumbsDir = "${thumbs}/bin";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/fcsonline/tmux-thumbs";
    description = "A lightning fast version of tmux-fingers written in Rust for copy pasting with vimium/vimperator like hints.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ghostbuster91 ];
  };
}
