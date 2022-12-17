{ stdenv
, lib
, fetchFromGitHub
, elkhound
, ocaml-ng
, perl
, which
, gnumake42
}:

let
  # 1. Needs ocaml >= 4.04 and <= 4.11
  # 2. ocaml 4.10 defaults to safe (immutable) strings so we need a version with
  #    that disabled as weidu is strongly dependent on mutable strings
  ocaml' = ocaml-ng.ocamlPackages_4_11.ocaml.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [
      # https://github.com/WeiDUorg/weidu/issues/197
      "--disable-force-safe-string"
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "weidu";
  version = "249.00";

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+vkKTzFZdAzY2dL+mZ4A0PDxhTKGgs9bfArz7S6b4m4=";
  };

  postPatch = ''
    substitute sample.Configuration Configuration \
      --replace /usr/bin ${lib.makeBinPath [ ocaml' ]} \
      --replace elkhound ${elkhound}/bin/elkhound

    mkdir -p obj/{.depend,x86_LINUX}
  '';

  nativeBuildInputs = [ elkhound ocaml' perl which gnumake42 ];

  buildFlags = [ "weidu" "weinstall" "tolower" ];

  installPhase = ''
    runHook preInstall

    for b in tolower weidu weinstall; do
      install -Dm555 $b.asm.exe $out/bin/$b
    done

    install -Dm444 -t $out/share/doc/weidu README* COPYING

    runHook postInstall
  '';

  meta = with lib; {
    description = "InfinityEngine Modding Engine";
    homepage = "https://weidu.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    # should work fine on both Darwin and Windows
    platforms = platforms.linux;
  };
}
