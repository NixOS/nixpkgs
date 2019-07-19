{ stdenv, lib, fetchFromGitHub, python }:

with lib;

stdenv.mkDerivation rec {
  name = "lipx-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = "Lipx";
    rev = "1c01fcff06f1015750ad5461d5c898cba692326d";
    sha256 = "0mgjpbzx9anap513wc4pn313k424hm93rvbxgdij54zps89k8qf9";
  };

  nativeBuildInputs = [ python ];

  buildCommand = ''
    install -vD $src/lipx.py $out/bin/lipx
    chmod u+x $out/bin/lipx
    patchShebangs $out/bin/lipx
  '';

  meta = {
    description = "IPS patcher";
    homepage = https://github.com/kylon/Lipx;
    maintainers = [ maintainers.coconnor ];
  };
}
