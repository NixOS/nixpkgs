{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, docutils, removeReferencesTo }:

stdenv.mkDerivation {
  pname = "${varnish.name}-modules";
  version = "2020-03-03";

  src = {
    "6.0.5" = fetchFromGitHub {
      owner = "varnish";
      repo = "varnish-modules";
      rev = "0d555b627333cd9190a40870f380ace5664f6d0d"; # https://github.com/varnish/varnish-modules/commits/6.0
      sha256 = "1lwgjhgr5yw0d17kbqwlaj5pkn70wvaqqjpa1i0n459nx5cf5pqj";
    };
    "6.2.2" = fetchFromGitHub {
      owner = "varnish";
      repo = "varnish-modules";
      rev = "3608d1ec11793de1bc94492b4a2d1b8d48a6ca98"; # https://github.com/varnish/varnish-modules/commits/6.2
      sha256 = "0b6vvx3sfm5rd38dn32pxbzdvx2nvjsr61fywz1qbx25y3q5mczh";
    };
    "6.3.1" = fetchFromGitHub {
      owner = "varnish";
      repo = "varnish-modules";
      rev = "0f695f4c485029c77cb4d22b97d2bde32f5c8d3d"; # https://github.com/varnish/varnish-modules/commits/6.3
      sha256 = "0s6ylfsifvk6dq6vvnbfy14jvz8lnfynlsxi8lgixls3j2h7rnmw";
    };
  }.${varnish.version};

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkgconfig
    removeReferencesTo
    varnish.python  # use same python version as varnish server
  ];

  buildInputs = [ varnish ];

  postPatch = ''
    substituteInPlace bootstrap   --replace "''${dataroot}/aclocal"                  "${varnish.dev}/share/aclocal"
    substituteInPlace Makefile.am --replace "''${LIBVARNISHAPI_DATAROOTDIR}/aclocal" "${varnish.dev}/share/aclocal"
  '';

  postInstall = "find $out -type f -exec remove-references-to -t ${varnish.dev} '{}' +"; # varnish.dev captured only as __FILE__ in assert messages

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Collection of Varnish Cache modules (vmods) by Varnish Software";
    homepage = https://github.com/varnish/varnish-modules;
    inherit (varnish.meta) license platforms maintainers;
    broken = versionAtLeast varnish.version "6.2"; # tests crash with core dump
  };
}
