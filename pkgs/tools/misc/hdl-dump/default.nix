{ stdenv, fetchFromGitHub, upx }:

stdenv.mkDerivation rec {
  version = "0.9.2.20202807";
  pname = "hdl_dump";

  # playstation2/hdl-dump is outdated
  src = fetchFromGitHub {
    owner = "AKuHAK";
    repo = "hdl-dump";
    rev = "be37e112a44772a1341c867dc3dfee7381ce9e59";
    sha256 = "0akxak6hm11h8z6jczxgr795s4a8czspwnhl3swqxp803dvjdx41";
  };

  buildInputs = [ upx ];

  makeFlags = [ "RELEASE=yes" ];

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ makefu ];
  };
}
