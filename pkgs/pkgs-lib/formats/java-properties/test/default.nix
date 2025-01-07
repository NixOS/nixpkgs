{
  formats,
  glibcLocales,
  jdk,
  lib,
  stdenv,
}:

# This test primarily tests correct escaping.
# See also testJavaProperties in
# pkgs/pkgs-lib/tests/formats.nix, which tests
# type coercions and is a bit easier to read.

let
  inherit (lib) concatStrings attrValues mapAttrs;

  javaProperties = formats.javaProperties { };

  input = {
    foo = "bar";
    "empty value" = "";
    "typical.dot.syntax" = "com.sun.awt";
    "" = "empty key's value";
    "1" = "2 3";
    "#" = "not a comment # still not";
    "!" = "not a comment!";
    "!a" = "still not! a comment";
    "!b" = "still not ! a comment";
    "dos paths" = "C:\\Program Files\\Nix For Windows\\nix.exe";
    "a \t\nb" = " c";
    "angry \t\nkey" = ''
      multi
      ${"\tline\r"}
       space-
        indented
      trailing-space${" "}
      trailing-space${"  "}
      value
    '';
    "this=not" = "bad";
    "nor = this" = "bad";
    "all stuff" = "foo = bar";
    "unicode big brain" = "e = mc□";
    "ütf-8" = "dûh";
    # NB: Some editors (vscode) show this _whole_ line in right-to-left order
    "الجبر" = "أكثر من مجرد أرقام";
  };

in
stdenv.mkDerivation {
  name = "pkgs.formats.javaProperties-test-${jdk.name}";
  nativeBuildInputs = [
    jdk
    glibcLocales
  ];

  # technically should go through the type.merge first, but that's tested
  # in tests/formats.nix.
  properties = javaProperties.generate "example.properties" input;

  # Expected output as printed by Main.java
  passAsFile = [ "expected" ];
  expected = concatStrings (
    attrValues (
      mapAttrs (key: value: ''
        KEY
        ${key}
        VALUE
        ${value}

      '') input
    )
  );

  src = lib.sourceByRegex ./. [
    ".*\.java"
  ];
  # On Linux, this can be C.UTF-8, but darwin + zulu requires en_US.UTF-8
  LANG = "en_US.UTF-8";
  buildPhase = ''
    javac Main.java
  '';
  doCheck = true;
  checkPhase = ''
    cat -v $properties
    java Main $properties >actual
    diff -U3 $expectedPath actual
  '';
  installPhase = "touch $out";
}
