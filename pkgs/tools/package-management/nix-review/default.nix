{ stdenv
, python3
, fetchFromGitHub
, nix
, git
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "0dv6hzmfqyhfi6zzjm10nzzqiy2wyfhiksm1cd4fznq0psxaihfj";
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
