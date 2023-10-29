{ pkgs, dcompiler ? pkgs.ldc, fetchFromGitHub }:
with (import ./mkDub.nix { inherit pkgs dcompiler; });
mkDubDerivation {
  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dfmt";
    rev = "v0.15.0";
    hash = "sha256-JC/6XZxMT/2JY14SkrTBntlO5gPhteZN+k112DKrCIc=";
  };
  buildInputs = [ pkgs.makeWrapper pkgs.cacert pkgs.nix-prefetch-git ];
  postFixup = ''
    wrapProgram $out/bin/dfmt --prefix PATH : ${pkgs.nix-prefetch-git}/bin
  '';
  deps = [{
    fetch = {
      type = "git";
      url = "https://github.com/dlang-community/libdparse.git";
      rev = "v0.23.2";
      sha256 = "0051pl8g7wwcgyqzs8yi0yq366mmiqv423hblaml4x0bq5q6ny5g";
      fetchSubmodules = false;
      date = "2023-07-05T20:33:47+02:00";
      deepClone = false;
      leaveDotGit = false;
      path = "/nix/store/i8ysxxib53kknswghdin9k59xk6r24x4-libdparse";
    };
  }];

  meta = with pkgs.lib; {
    homepage = "https://github.com/dlang-community/dfmt";
  };

}
