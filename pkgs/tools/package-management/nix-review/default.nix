{ stdenv
, python3
, fetchFromGitHub
, nix
, makeWrapper
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-review";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-review";
    rev = version;
    sha256 = "138f9m2c8fwpvn3kv5q7845ffi1pjbqxcs44aych4832i0pn6jaf";
  };

  buildInputs = [ makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/nix-review --prefix PATH : ${nix}/bin
  '';

  meta = with stdenv.lib; {
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = https://github.com/Mic92/nix-review;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
