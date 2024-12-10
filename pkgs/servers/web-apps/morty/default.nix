{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "morty";
  version = "unstable-2021-04-22";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "morty";
    rev = "f5bff1e285d3f973cacf73318e55175edafd633f";
    sha256 = "sha256-ik2VAPdxllt76UVFt77c1ltxIwFNahAKjn3FuErNFYo=";
  };

  vendorHash = "sha256-3sllcoTDYQBAyAT7e9KeKNrlTEbgnoZc0Vt0ksQByvo=";

  meta = with lib; {
    description = "Privacy aware web content sanitizer proxy as a service";
    mainProgram = "morty";
    longDescription = ''
      Morty rewrites web pages to exclude malicious HTML tags and attributes.
      It also replaces external resource references to prevent third party information leaks.

      The main goal of morty is to provide a result proxy for searx, but it can be used as a standalone sanitizer service too.
    '';
    homepage = "https://github.com/asciimoo/morty";
    maintainers = with maintainers; [
      leenaars
      SuperSandro2000
    ];
    license = licenses.agpl3Only;
  };
}
