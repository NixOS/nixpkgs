{ stdenv, fetchFromGitHub, bash, curl, xsel }:

stdenv.mkDerivation rec {
  name = "imgurbash2-${version}";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "ram-on";
    repo = "imgurbash2";
    rev = version;
    sha256 = "1vdkyy0gvjqwc2g7a1lqx6cbynfxbd4f66m8sg1xjvd0kdpgi9wk";
  };

  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF >$out/bin/imgurbash2
    #!${bash}/bin/bash
    PATH=${stdenv.lib.makeBinPath [curl xsel]}:\$PATH
    EOF
    cat imgurbash2 >> $out/bin/imgurbash2
    chmod +x $out/bin/imgurbash2
  '';

  meta = with stdenv.lib; {
    description = "A shell script that uploads images to imgur";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
    homepage = https://github.com/ram-on/imgurbash2;
  };
}
