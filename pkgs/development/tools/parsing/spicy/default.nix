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
  version = "1.7.0";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "v${version}";
    hash = "sha256-axeBD1wjMc5HZy+0Oi5wltr7M6zrQI/NzU6717vUpg0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
    python3
  ];

  buildInputs = [
    bison
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
    description = "A C++ parser generator for dissecting protocols & files";
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
