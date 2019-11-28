{ stdenv, fetchFromGitLab, makeWrapper, xorgserver, getopt, xauth, utillinux, fontsConf, gawk
, coreutils }:

stdenv.mkDerivation rec {
  pname = "xvfb-run";
  version = "1.20.6-1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    group = "xorg-team";
    owner = "xserver";
    repo = "xorg-server";
    rev = "acb49777829b320d58a3a6c65828aabfffeb381e";
    sha256 = "1ci6wzka62iwihccl4g48rm0fj119jg38z9nvxhwi0v7dvlvkwvh";
  };

  phases = [ "unpackPhase" "installPhase" ];

  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1
    install -m 555 debian/local/xvfb-run $out/bin/xvfb-run
    install debian/local/xvfb-run.1 $out/share/man/man1/xvfb-run.1

    patchShebangsAuto
    wrapProgram $out/bin/xvfb-run \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth utillinux gawk coreutils ]}
  '';

  meta = with stdenv.lib; {
    description = ''Starter script for an instance of Xvfb, the "fake" X server'';
    inherit (src.meta) homepage;
    license = licenses.gpl2;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.linux;
  };
}
