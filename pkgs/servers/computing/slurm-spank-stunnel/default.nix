{ lib, stdenv, fetchFromGitHub, slurm } :

stdenv.mkDerivation rec {
  pname = "slurm-spank-stunnel";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "stanford-rc";
    repo = "slurm-spank-stunnel";
    rev = version;
    sha256 = "15cpd49ccvzsmmr3gk8svm2nz461rvs4ybczckyf4yla0xzp06gj";
  };

  buildPhase = ''
    gcc -I${slurm.dev}/include -shared -fPIC -o stunnel.so slurm-spank-stunnel.c
  '';

  installPhase = ''
    mkdir -p $out/lib $out/etc/slurm/plugstack.conf.d
    install -m 755 stunnel.so $out/lib
    install -m 644 plugstack.conf $out/etc/slurm/plugstack.conf.d/stunnel.conf.example
  '';

  meta = with lib; {
    homepage = "https://github.com/stanford-rc/slurm-spank-stunnel";
    description = "Plugin for SLURM for SSH tunneling and port forwarding support";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ markuskowa ];
  };
}
