{
  lib,
  stdenv,
  fetchFromGitHub,
  Carbon,
}:

stdenv.mkDerivation {
  pname = "qes";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "koekeishiya";
    repo = "qes";
    rev = "ddedf008f0c38b134501ad9f328447b671423d34"; # no tag
    sha256 = "1w9ppid7jg6f4q7pq40lhm0whg7xmnxcmf3pb9xqfkq2zj2f7dxv";
  };

  buildInputs = [ Carbon ];

  makeFlags = [ "BUILD_PATH=$(out)/bin" ];

  meta = with lib; {
    description = "Quartz Event Synthesizer";
    homepage = "https://github.com/koekeishiya/qes";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ lnl7 ];
    license = licenses.mit;
  };
}
