{ lib, buildGoModule, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "3mux";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QT4QXTlJf2NfTqXE4GF759EoW6Ri12lxDyodyEFc+ag=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorSha256 = "sha256-tbziQZIA1+b+ZtvA/865c8YQxn+r8HQy6Pqaac2kwcU=";

  # This is a package used for internally testing 3mux. It's meant for
  # use by 3mux maintainers/contributors only.
  excludedPackages = [ "fuzz" ];

  # 3mux needs to have itself in the path so users can run `3mux detach`.
  # This ensures that, while inside 3mux, the binary in the path is the
  # same version as the 3mux hosting the session. This also allows users
  # to use 3mux via `nix run nixpkgs#_3mux` (otherwise they'd get "command
  # not found").
  postInstall = ''
    wrapProgram $out/bin/3mux --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Terminal multiplexer inspired by i3";
    longDescription = ''
      Terminal multiplexer with out-of-the-box support for search,
      mouse-controlled scrollback, and i3-like keybindings
    '';
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse Br1ght0ne ];
    platforms = platforms.unix;
  };
}
