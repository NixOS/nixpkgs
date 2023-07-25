{ lib, stdenv, fetchFromGitHub, makeWrapper, viu }:

stdenv.mkDerivation rec {
  pname = "uwufetch";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "TheDarkBug";
    repo = pname;
    rev = version;
    hash = "sha256-cA8sajh+puswyKikr0Jp9ei+EpVkH+vhEp+pTerkUqA=";
  };

  postPatch = ''
    substituteInPlace uwufetch.c \
      --replace "/usr/lib/uwufetch" "$out/lib/uwufetch" \
      --replace "/usr/local/lib/uwufetch" "$out/lib/uwufetch" \
      --replace "/etc/uwufetch/config" "$out/etc/uwufetch/config"
    # fix command_path for package manager (nix-store)
    substituteInPlace fetch.c \
      --replace "/usr/bin" "/run/current-system/sw/bin"
  '' + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace "local/bin" "bin" \
      --replace "local/lib" "lib" \
      --replace "local/include" "include" \
      --replace "local/share" "share"
  '';

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "UWUFETCH_VERSION=${version}"
  ];

  installFlags = [
    "DESTDIR=${placeholder "out"}"
    "ETC_DIR=${placeholder "out"}/etc"
  ];

  postFixup = ''
    wrapProgram $out/bin/uwufetch \
      --prefix PATH ":" ${lib.makeBinPath [ viu ]}
  '';

  meta = with lib; {
    description = "A meme system info tool for Linux";
    homepage = "https://github.com/TheDarkBug/uwufetch";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lourkeur ];
  };
}
