{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "z-${version}";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "rupa";
    repo = "z";
    rev = "v${version}";
    sha256 = "13zbgkj6y0qhvn5jpkrqbd4jjxjr789k228iwma5hjfh1nx7ghyb";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm 644 z.sh "$out/share/z.sh"
    install -Dm 644 z.1 "$out/share/man/man1/z.1"

    mkdir "$out/bin"
    cat > "$out/bin/z-share" <<EOF
      #!/bin/sh
      echo "$out/share/z.sh"
    EOF
    chmod +x "$out/bin/z-share"
  '';

  meta = with stdenv.lib; {
    description = "Tracks your most used directories, based on 'frecency'";
    homepage = https://github.com/rupa/z;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ marsam jD91mZM2 ];
  };
}
