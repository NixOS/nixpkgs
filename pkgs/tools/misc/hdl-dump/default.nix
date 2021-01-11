{ lib, stdenv
, fetchFromGitHub
, upx
}:

let
  version = "20202807";
  pname = "hdl-dump";
in stdenv.mkDerivation {
  inherit pname version;

  # Using AkuHAK's repo because playstation2's repo is outdated
  src = fetchFromGitHub {
    owner = "AKuHAK";
    repo = pname;
    rev = "be37e112a44772a1341c867dc3dfee7381ce9e59";
    sha256 = "0akxak6hm11h8z6jczxgr795s4a8czspwnhl3swqxp803dvjdx41";
  };

  buildInputs = [ upx ];

  makeFlags = [ "RELEASE=yes" ];

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/AKuHAK/hdl-dump";
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ makefu ];
  };
}
