{ lib
, stdenv
, fetchFromGitHub
, cmake
, makeWrapper
, python3
, bison
, flex
, zlib
}:

stdenv.mkDerivation rec {
  pname = "spicy";
  version = "1.11.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "v${version}";
    hash = "sha256-gSfj5d8g2eQGhaT4dGyNPqWy+9GkDxMkMuZ7vKnhFVQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bison
    cmake
    flex
    makeWrapper
    python3
  ];

  buildInputs = [
    flex
    zlib
  ];

  postPatch = ''
    patchShebangs scripts tests/scripts
  '';

  cmakeFlags = [
    "-DHILTI_DEV_PRECOMPILE_HEADERS=OFF"
  ];

  preFixup = ''
    for b in $out/bin/*
      do wrapProgram "$b" --prefix PATH : "${lib.makeBinPath [ bison flex ]}"
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/zeek/spicy";
    description = "C++ parser generator for dissecting protocols & files";
    longDescription = ''
      Spicy is a parser generator that makes it easy to create robust C++
      parsers for network protocols, file formats, and more. Spicy is a bit
      like a "yacc for protocols", but it's much more than that: It's an
      all-in-one system enabling developers to write attributed grammars that
      describe both syntax and semantics of an input format using a single,
      unified language. Think of Spicy as a domain-specific scripting language
      for all your parsing needs.
    '';
    license = licenses.bsd3;
    maintainers = with maintainers; [ tobim ];
  };
}
