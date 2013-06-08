{fetchurl, stdenv, perl, openssh, rsync, logger}:

stdenv.mkDerivation rec {
  name = "rsnapshot-1.3.0";
  src = fetchurl {
    url = "mirror://sourceforge/rsnapshot/${name}.tar.gz";
    sha256 = "19p35ycm73a8vd4ccjpah18h5jagvcr11rqca6ya87sg8k0a5h9z";
  };

  propagatedBuildInputs = [perl openssh rsync logger];

  patchPhase = ''
    substituteInPlace "Makefile.in" --replace \
      "/usr/bin/pod2man" "${perl}/bin/pod2man"
  '';

  meta = {
    description = "A filesystem snapshot utility for making backups of local and remote systems";
    homepage = http://rsnapshot.org/;
    license = "GPLv2+";
  };
}
