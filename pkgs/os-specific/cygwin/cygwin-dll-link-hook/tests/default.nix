{
  dieHook,
  lib,
  stdenv,
  testers,
  runCommand,
}:

rec {
  dll = stdenv.mkDerivation {
    name = "dll";
    src = ./dll;
    outputs = [
      "out"
      "dev"
    ];
    buildInputs = [ dll2 ];
    strictDeps = true;
  };

  dll2 = stdenv.mkDerivation {
    name = "dll2";
    src = ./dll2;
    outputs = [
      "out"
      "dev"
    ];
  };

  exe = stdenv.mkDerivation {
    name = "exe";
    src = ./exe;
    buildInputs = [ dll ];
    nativeBuildInputs = [ dieHook ];
    strictDeps = true;
    doCheck = true;
    postFixup = ''[[ -e "$out"/bin/cyghello2.dll ]] || die missing indirect dependency'';
  };

  link-dll = exe.overrideAttrs {
    name = "link-dll";
    preFixup = ''
      ln -s ${lib.getLib dll}/bin/cyghello.dll "$out"/bin/
    '';
  };

  user32 = stdenv.mkDerivation {
    name = "user32";
    src = ./user32;
    allowedImpureDLLs = [ "USER32.dll" ];
  };

  impure-dll = testers.testBuildFailure (
    user32.overrideAttrs {
      name = "impure-dll";
      allowedImpureDLLs = [ ];
    }
  );

  user32-dll = stdenv.mkDerivation {
    name = "user32-dll";
    src = ./user32-dll;
    outputs = [
      "out"
      "dev"
    ];
    allowedImpureDLLs = [ "USER32.dll" ];
  };

  user32-exe = stdenv.mkDerivation {
    name = "user32-exe";
    src = ./user32-exe;
    buildInputs = [ user32-dll ];
    strictDeps = true;
    doCheck = true;
  };

  link-dir-dll = exe.overrideAttrs {
    name = "link-dir-dll";
    preFixup = ''
      mkdir "$out"/libexec
      ln -s ${lib.getLib user32-dll}/bin/cygpeek.dll "$out"/libexec/
      linkDLLsDir="$out"/bin linkDLLs "$out"/libexec/cygpeek.dll
    '';
  };

  link-dir-exe = exe.overrideAttrs {
    name = "link-dir-exe";
    preFixup = ''
      mkdir "$out"/libexec
      ln -s ${lib.getLib user32-exe}/bin/{peek.exe,cygpeek.dll} "$out"/libexec/
      linkDLLsDir="$out"/bin linkDLLs "$out"/libexec/peek.exe
    '';
  };

  link-user32-dll = exe.overrideAttrs {
    name = "link-user32-dll";
    preFixup = ''
      ln -s ${lib.getLib user32-dll}/bin/cygpeek.dll "$out"/bin/
    '';
  };

  copy-dll-impure = testers.testBuildFailure (
    user32-exe.overrideAttrs {
      name = "copy-dll-impure";
      preFixup = ''
        cp ${lib.getLib user32-dll}/bin/cygpeek.dll "$out"/bin/
      '';
    }
  );

  copy-dll = user32-exe.overrideAttrs {
    name = "copy-dll";
    preFixup = ''
      cp ${lib.getLib user32-dll}/bin/cygpeek.dll "$out"/bin/
      linkDLLs "$out"/bin/cygpeek.dll
    '';
    allowedImpureDLLs = [ "USER32.dll" ];
  };

  double-link = user32-exe.overrideAttrs {
    name = "double-link";
    preFixup = ''linkDLLs "$out"'';
  };

  utf8-glob = runCommand "utf8-glob" { } ''
    touch NetLock_Arany_=Class_Gold=_Főtanstvny:49412ce40010.crt
    ls -l NetLock* > "$out"
  '';
}
