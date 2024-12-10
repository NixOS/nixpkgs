{
  screenshots ? true,
  video ? false,
  clipboard ? true,
  lib,
  stdenv,
  jq,
  curl,
  fetchFromGitHub,
  makeWrapper,
  maim ? null,
  xclip ? null,
  capture ? null,
}:

assert screenshots -> maim != null;
assert video -> capture != null;
assert clipboard -> xclip != null;

stdenv.mkDerivation rec {
  pname = "pb_cli-unstable";
  version = "2019-03-10";

  src = fetchFromGitHub {
    owner = "ptpb";
    repo = "pb_cli";
    rev = "6b9ce1ee45fe651d06d7c479a20026a173dd328b";
    sha256 = "0w6a789zffvz4ixsb92q45n5s4xyx7s2l2f07972i3dajaaai8z7";
  };

  nativeBuildInputs = [ makeWrapper ];

  liveDeps =
    [
      jq
      curl
    ]
    ++ lib.optional screenshots maim
    ++ lib.optional video capture
    ++ lib.optional clipboard xclip;

  installPhase = ''
    install -Dm755 src/pb.sh $out/bin/pb

    patchShebangs $out/bin/pb
    wrapProgram $out/bin/pb \
      --prefix PATH : '${lib.makeBinPath liveDeps}'
  '';

  meta = with lib; {
    description = "A no bullshit 0x0.st client";
    homepage = "https://github.com/ptpb/pb_cli";
    maintainers = [ maintainers.ar1a ];
    license = licenses.gpl3Plus;
    mainProgram = "pb";
  };
}
