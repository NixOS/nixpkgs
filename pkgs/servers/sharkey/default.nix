{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, nodejs
, nodePackages
, python3
, glib
, glibc
, vips
, musl
}:
stdenv.mkDerivation rec {
  pname = "sharkey";
  version = "2023.9.1.beta5";

  nativeBuildInputs = [
    autoPatchelfHook
    nodejs
    nodePackages.pnpm
    python3
  ];

  buildInputs = [
    glib
    vips
    glibc
    musl
  ];

  src = fetchurl {
    url = "https://github.com/transfem-org/Sharkey/releases/download/${version}/sharkey-linux-x64.tar.gz";
    hash = "sha256-JxaeL/uaRifVUKFiMB584+AMQXePEhPFNgDmAldmeQ8=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/packages/frontend
    ln -s /var/lib/sharkey $out/files
    ln -s /run/sharkey $out/.config
    cp -r locales fluent-emojis misskey-assets node_modules built $out
    cp -r packages/backend $out/packages/backend
    cp -r packages/frontend/assets $out/packages/frontend/assets
  '';

  meta = with lib; {
    description = "A Sharkish microblogging platform";
    homepage = "https://joinsharkey.org";
    platforms = platforms.linux;
    architectures = [ "amd64" ];
    changelog = "https://github.com/transfem-org/Sharkey/releases/tag/${version}";
    license = licenses.agpl3;
    maintainers = with maintainers; [ aprl ];
  };
}
