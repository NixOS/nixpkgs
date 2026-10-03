{
  fetchFromGitHub,
  stdenv,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fluxer-static";
  version = "2026.929.230311";

  src = fetchFromGitHub {
    owner = "fluxerapp";
    repo = "fluxer";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-3RNQ0hjTiYuiXnR9281R52a7sUzKwQD5Y52nEFD7gI8=";
  };

  installPhase = ''
    mkdir -p $out/share/fluxer-static

    cp -r fluxer_static/{avatars,badges,desktop,embeds,emoji,web} $out/share/fluxer-static
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP chat app";
    license = lib.licenses.agpl3Only;
    homepage = "https://github.com/fluxerapp/fluxer";
    maintainers = [ lib.maintainers.strangeglyph ];
  };
})
