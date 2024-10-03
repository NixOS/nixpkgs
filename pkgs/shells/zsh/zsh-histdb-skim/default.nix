{ lib, rustPlatform, fetchFromGitHub, sqlite, pkgconfig, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "zsh-histdb-skim";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "m42e";
    repo = pname;
    rev = "f00f63f13f69c5d05daf9b9a059b55aa521a53fe";
    sha256 = "sha256-PF8BxFEyNIe8zTO1CyGjNI8T9RyQ1e53ZlK+/LkOkKM=";
  };
  cargoSha256 = "sha256-a5a0JdVVkWrMw3F9mpgkj2US3mS9YHzpdkjgMlep9xw=";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ sqlite ];

  postInstall = ''
    # use the vendored zsh script which doesn't support autoupdating; don't
    # install the one capable of autoupdates.
    install -D zsh-histdb-skim-vendored.zsh $out/share/zsh/plugins/zsh-histdb-skim/zsh-histdb-skim.zsh
    chmod +x $out/share/zsh/plugins/zsh-histdb-skim/zsh-histdb-skim.zsh
  '';

  meta = with lib; {
    description = "A zsh histdb browser using skim.";
    homepage = "https://github.com/m42e/zsh-histdb-skim";
    license = licenses.mit;
    maintainers = with maintainers; [ sielicki ];
  };
}
