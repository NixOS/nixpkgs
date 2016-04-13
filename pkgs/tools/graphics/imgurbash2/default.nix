{ stdenv, fetchFromGitHub, bash, curl, xsel }:

stdenv.mkDerivation rec {
  name = "imgurbash2-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ram-on";
    repo = "imgurbash2";
    rev = version;
    sha256 = "0w8xfdvv6h0cqln9a2b1rskpyv4v5qsywqzg10smg05xlrh9f5nx";
  };

  installPhase = ''
    mkdir -p $out/bin
    cat <<EOF >$out/bin/imgurbash2
    #!${bash}/bin/bash
    PATH=${stdenv.lib.makeSearchPath "bin" [curl xsel]}:\$PATH
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
