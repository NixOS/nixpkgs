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
    rev = "xorg-server-2_${version}";
    sha256 = "03a2x0fds45j7dqsp31ifsr1bm8zl6yac925n0bqdf4sjiyscq20";
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
    description = "A wrapper for the Xvfb command which simplifies the task of running commands";
    homepage = src.meta.homepage +  "debian/local";
    license = licenses.mit;
    maintainers = with maintainers; [ b4dm4n ];
    platforms = platforms.linux;
  };
}
