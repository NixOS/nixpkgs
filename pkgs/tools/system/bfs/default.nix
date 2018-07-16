{ stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation rec {
  name = "bfs-${version}";
  version = "1.2.2";

  src = fetchFromGitHub {
    repo = "bfs";
    owner = "tavianator";
    rev = version;
    sha256 = "0a7zsipvndvg1kp2i35jrg9y9kncj7i6mp36dhpj8zjmkm5d5b8g";
  };

  # Disable fstype test, tries to read /etc/mtab
  patches = [ ./tests.patch ];
  postPatch = ''
    # Patch tests (both shebangs and usage in scripts)
    for f in $(find -type f -name '*.sh'); do
      substituteInPlace $f --replace "/bin/bash" "${bash}/bin/bash"
    done
  '';
  doCheck = true;

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "release" ]; # "release" enables compiler optimizations

  meta = with stdenv.lib; {
    description = "A breadth-first version of the UNIX find command";
    longDescription = ''
      bfs is a variant of the UNIX find command that operates breadth-first rather than
      depth-first. It is otherwise intended to be compatible with many versions of find.
    '';
    homepage = https://github.com/tavianator/bfs;
    license = licenses.bsd0;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yesbox ];
  };
}
