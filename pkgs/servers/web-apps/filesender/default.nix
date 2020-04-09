{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "filesender";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "filesender";
    repo = pname;
    rev = "master-filesender-${version}";
    sha256 = "0b53rv5i44cqc94im15ampigj9s5p0i3yzq7gqxkxfw6d5l688bp";
  };

  patches = [
    # Filesender searches for the configuration in the same directory tree as
    # the other source code. This patch makes it possible to define a different
    # location for the configuration directory so the NixOS service can write
    # the configuration without modifying the entire package.
    ./config_dir.patch
  ];

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = with stdenv.lib; {
    description = "Web application for sending large files to other users";
    homepage = "https://filesender.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jluttine ];
  };
}
