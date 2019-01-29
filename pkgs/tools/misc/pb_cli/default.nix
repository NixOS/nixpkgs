{ screenshots ? true, video ? false, clipboard ? true
, stdenv, pkgs, jq, curl, fetchFromGitHub, makeWrapper, maim ? null, xclip ? null, capture ? null }:

assert screenshots -> maim != null;
assert video -> capture != null;
assert clipboard -> xclip != null;

stdenv.mkDerivation rec {
  name = "pb_cli-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ptpb";
    repo = "pb_cli";
    rev  = "5242382b3d6b5c0ddaf6e4843a69746b40866e57";
    sha256 = "0543x3377apinhxnsfq82zlp5sm8g1bf6hmsvvcwra5rsshv2ybk";
  };

  patches = [ ./0001-eval-fix.patch ];

  buildInputs = [ makeWrapper ];

  liveDeps = [ jq curl ] ++ stdenv.lib.optional screenshots maim
                         ++ stdenv.lib.optional video capture
                         ++ stdenv.lib.optional clipboard xclip;

  installPhase = ''
    install -Dm755 src/pb.sh $out/bin/pb

    patchShebangs $out/bin/pb
    wrapProgram $out/bin/pb \
      --prefix PATH : '${stdenv.lib.makeBinPath liveDeps}'
  '';

  meta = with stdenv.lib; {
    description = "A no bullshit ptpb client";
    homepage = "https://github.com/ptpb/pb_cli";
    maintainers = [ maintainers.ar1a ];
  };
}
