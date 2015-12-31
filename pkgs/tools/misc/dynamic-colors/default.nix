{ stdenv, fetchFromGitHub, makeWrapper, tmux, vim }:

stdenv.mkDerivation rec {
  name = "dynamic-colors-git-${version}";
  version = "2013-12-28";

  src = fetchFromGitHub {
    owner = "sos4nt";
    repo = "dynamic-colors";
    rev = "35325f43620c5ee11a56db776b8f828bc5ae1ddd";
    sha256 = "1xsjanqyvjlcj1fb8x4qafskxp7aa9b43ba9gyjgzr7yz8hkl4iz";
  };

  buildInputs = [ makeWrapper ];

  patches = [ ./separate-config-and-dynamic-root-path.patch ];

  installPhase = ''
    mkdir -p $out/bin $out/etc/bash_completion.d $out/share/dynamic-colors
    cp bin/dynamic-colors $out/bin/
    cp completions/dynamic-colors.bash $out/etc/bash_completion.d/
    cp -r colorschemes $out/share/dynamic-colors/

    sed -e 's|\<tmux\>|${tmux}/bin/tmux|g' \
        -e 's|/usr/bin/vim|${vim}/bin/vim|g' \
        -i "$out/bin/dynamic-colors"

    wrapProgram $out/bin/dynamic-colors --set DYNAMIC_COLORS_ROOT "$out/share/dynamic-colors"
  '';

  meta = {
    homepage = https://github.com/sos4nt/dynamic-colors;
    license = stdenv.lib.licenses.mit;
    description = "Change terminal colors on the fly";
    platforms = stdenv.lib.platforms.unix;
  };
}
