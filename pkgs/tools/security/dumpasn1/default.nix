{ lib, stdenv, fetchFromGitLab, help2man }:

let
  pname = "dumpasn1";
  version = "20210212";
  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = pname;
    rev = "7a10baa8eebcef053c100b27a70e245313611cbb";
    sha256 = "0a4nhzj30i5d1wqpjrxi1a93x0h19yzf9z2nrb2ri5qy5yc6p1iw";
  };

  patches = [ ./paths.patch ];

  nativeBuildInputs = lib.optional (!isCross) help2man;

  makefile = "debian/rules";
  makeFlags = [ "CPPFLAGS=-DPREFIX=$(prefix)" "VER_FULL=${version}" ];

  buildFlags = [ pname ] ++ lib.optional (!isCross) "debian/${pname}.1";

  installPhase = ''
    runHook preInstall
    install -Dm 755 -t $out/bin/ ${pname}
    install -Dm 644 -t $out/share/${pname}/ ${pname}.cfg
    ${lib.optionalString (!isCross) ''
    install -Dm 644 -t $out/share/man/man1/ debian/${pname}.1
    ''}
    runHook postInstall
  '';

  meta = with lib; {
    description = ''
      ASN.1 object dump program that will dump data encoded using any of the ASN.1
      encoding rules in a variety of user-specified formats
    '';
    homepage = "https://www.cs.auckland.ac.nz/~pgut001/";
    maintainers = with maintainers; [ alexshpilkin ];
    license = licenses.dumpasn1;
  };
}
