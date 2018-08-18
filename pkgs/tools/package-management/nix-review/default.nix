{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "0lfwikcxnjjb10ssawkfgq7k8i86lsdcn0c0plwi9hgpxl2b52mp";
  };

  buildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/nix-review --prefix PATH : ${stdenv.lib.makeBinPath [
      git nix
    ]}
  '';

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = https://github.com/Mic92/nix-review;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
