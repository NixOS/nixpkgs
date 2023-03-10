{ lib, stdenv, fetchFromGitHub, bash, curl, xsel }:

stdenv.mkDerivation rec {
  pname = "imgurbash2";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "ram-on";
    repo = "imgurbash2";
    rev = version;
    sha256 = "sha256-7J3LquzcYX0wBR6kshz7VuPv/TftTzKFdWcgsML2DnI=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF >$out/bin/imgurbash2
    #!${bash}/bin/bash
    PATH=${lib.makeBinPath [curl xsel]}:\$PATH
    EOF
    cat imgurbash2 >> $out/bin/imgurbash2
    chmod +x $out/bin/imgurbash2
  '';

  meta = with lib; {
    description = "A shell script that uploads images to imgur";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
    homepage = "https://github.com/ram-on/imgurbash2";
  };
}
